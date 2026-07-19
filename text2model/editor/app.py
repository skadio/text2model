import ast
import csv
import datetime
import json
import os
import subprocess
import tempfile
from pathlib import Path
from typing import Any, Dict, Optional

import flet as ft
import openai

from text2model.utils import TEXT2ZINC_CSV_COLUMNS, TEXT2ZINC_DATASET

# Bundled seed dataset, shipped as package data — this is what the editor
# opens by default the very first time it's run in a fresh directory.
_PACKAGE_DIR = Path(__file__).parent
DEFAULT_DATASET_PATH = _PACKAGE_DIR / "data" / "text2zinc.csv"

# Where quick-save (the "Save" button / Ctrl+S) writes to, in the current
# working directory. "Save As..." lets the user pick any other destination —
# that destination is the "new text2zinc dataset" to pass to
# `text2model --dataset-path` / `evals/evaluate.py --dataset-path`.
WORKING_DATASET_PATH = "text2zinc_edited.csv"


def _parse_json_field(value: Any) -> Any:
    """Parse a dataset field that may already be a dict, a JSON string, or a
    Python-repr string (the format the skadio/text2zinc HF dataset uses)."""
    if isinstance(value, dict):
        return value
    if not value:
        return {}
    try:
        return json.loads(value)
    except (TypeError, ValueError):
        try:
            return ast.literal_eval(value)
        except (ValueError, SyntaxError):
            return value


class Text2ZincEditor:
    """Main dataset editor class that handles Text2Zinc dataset management"""

    def __init__(self):
        self.data = []
        self.current_index = 0
        self.csv_columns = TEXT2ZINC_CSV_COLUMNS

    def load_csv(self, filename: str) -> bool:
        """Load dataset from a local Text2Zinc CSV file"""
        try:
            data = []
            with open(filename, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    if 'input.json' in row:
                        row['input.json'] = _parse_json_field(row['input.json'])
                    if 'output.json' in row:
                        row['output.json'] = _parse_json_field(row['output.json'])
                    if 'is_verified' in row:
                        row['is_verified'] = str(row['is_verified']).lower() in ('true', '1', 'yes')
                    data.append(row)
            self.data = data
            self.current_index = 0
            return True
        except Exception as e:
            print(f"Error loading CSV: {e}")
            return False

    def load_from_huggingface(self) -> bool:
        """Load dataset fresh from the skadio/text2zinc HuggingFace dataset"""
        try:
            from datasets import load_dataset
            hf_dataset = load_dataset(TEXT2ZINC_DATASET)['train']

            data = []
            for row in hf_dataset:
                data.append({
                    'input.json': _parse_json_field(row.get('input.json')),
                    'data.dzn': row.get('data.dzn', '') or '',
                    'model.mzn': row.get('model.mzn', '') or '',
                    'output.json': _parse_json_field(row.get('output.json')),
                    'is_verified': bool(row.get('is_verified', False)),
                })
            self.data = data
            self.current_index = 0
            return True
        except Exception as e:
            print(f"Error loading dataset from HuggingFace: {e}")
            return False

    def save_csv(self, filename: str) -> bool:
        """Save dataset to a local Text2Zinc CSV file"""
        try:
            with open(filename, 'w', encoding='utf-8', newline='') as f:
                writer = csv.DictWriter(f, fieldnames=self.csv_columns, extrasaction='ignore')
                writer.writeheader()
                for row in self.data:
                    row_copy = {k: v for k, v in row.items() if k in self.csv_columns}

                    if isinstance(row_copy.get('input.json'), dict):
                        row_copy['input.json'] = json.dumps(row_copy['input.json'])
                    if isinstance(row_copy.get('output.json'), dict):
                        row_copy['output.json'] = json.dumps(row_copy['output.json'])
                    if 'is_verified' in row_copy:
                        row_copy['is_verified'] = str(row_copy['is_verified'])
                    writer.writerow(row_copy)
            return True
        except Exception as e:
            print(f"Error saving CSV: {e}")
            return False

    def get_current_item(self) -> Dict[str, Any]:
        """Get current item"""
        if not self.data or self.current_index >= len(self.data):
            return {}
        return self.data[self.current_index]

    def update_current_item(self, field: str, value: Any):
        """Update a field in the current item"""
        if self.data and self.current_index < len(self.data):
            self.data[self.current_index][field] = value

    def execute_minizinc(self,
                         model: str,
                         data: str,
                         problem_type: str = "optimization",
                         solver: str = "highs",
                         timeout: int = 60) -> Dict[str, Any]:
        """Execute MiniZinc model with data"""
        result = {
            'success': False,
            'output': '',
            'error': '',
            'json_output': None,
            'problem_type': problem_type
        }

        try:
            with tempfile.NamedTemporaryFile(mode='w', suffix='.mzn', delete=False) as model_file:
                model_file.write(model)
                model_path = model_file.name

            with tempfile.NamedTemporaryFile(mode='w', suffix='.dzn', delete=False) as data_file:
                data_file.write(data)
                data_path = data_file.name

            with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as output_file:
                output_path = output_file.name

            is_optimization = 'minimize' in model.lower() or 'maximize' in model.lower()

            cmd = ['minizinc', '--solver', solver, '--output-mode', 'json']
            if is_optimization:
                cmd.append('--output-objective')
            cmd.extend([model_path, data_path, '-o', output_path])

            process_result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)

            os.unlink(model_path)
            os.unlink(data_path)

            if process_result.returncode == 0:
                result['success'] = True
                try:
                    with open(output_path, 'r') as f:
                        output_text = f.read()

                    import re
                    json_match = re.search(r'{.*}', output_text, re.DOTALL)
                    if json_match:
                        json_str = json_match.group(0)
                        result['json_output'] = json.loads(json_str)
                        result['output'] = json.dumps(result['json_output'])
                    else:
                        result['output'] = output_text
                except Exception:
                    result['output'] = output_text if 'output_text' in locals() else process_result.stdout

                os.unlink(output_path)
            else:
                result['error'] = process_result.stderr
                result['output'] = process_result.stderr
                try:
                    os.unlink(output_path)
                except OSError:
                    pass

        except FileNotFoundError:
            result['error'] = "MiniZinc not found. Please install MiniZinc."
        except subprocess.TimeoutExpired:
            result['error'] = f"Execution timed out after {timeout} seconds."
        except Exception as e:
            result['error'] = str(e)

        return result


class ChatAssistant:
    """AI Chat Assistant using OpenAI API"""

    def __init__(self, api_key: str = ""):
        self.api_key = api_key
        self.client = None
        self.conversation_history = []
        self.current_context = {}
        if api_key:
            self.client = openai.OpenAI(api_key=api_key)

    def set_api_key(self, api_key: str):
        """Set OpenAI API key"""
        self.api_key = api_key
        self.client = openai.OpenAI(api_key=api_key)

    def update_context(self, context: Dict[str, Any]):
        """Update the current context for AI assistance"""
        self.current_context = context

    def send_message(self, user_message: str) -> str:
        """Send a message to the AI and get a response"""
        if not self.client:
            return "Error: OpenAI API key not set. Please set it in the settings."

        try:
            system_message = self._build_system_message()

            self.conversation_history.append({"role": "user", "content": user_message})

            # Keep only last 6 messages (6 turns = 3 user + 3 assistant)
            if len(self.conversation_history) > 6:
                self.conversation_history = self.conversation_history[-6:]

            messages = [{"role": "system", "content": system_message}] + self.conversation_history

            # gpt-5.2 is a reasoning model, so skip temperature/max_tokens (same pattern as utils.py)
            completion = self.client.chat.completions.create(model="gpt-5.2", messages=messages)

            assistant_message = completion.choices[0].message.content.strip()
            self.conversation_history.append({"role": "assistant", "content": assistant_message})

            return assistant_message

        except Exception as e:
            return f"Error communicating with OpenAI: {str(e)}"

    def _build_system_message(self) -> str:
        """Build a context-aware system message"""
        base_msg = """You are an expert assistant helping modeling and solving combinatorial problems using MiniZinc models.
You can help with:
- Rephrasing problem descriptions
- Generating or improving MiniZinc code
- Creating appropriate data files (.dzn format)
- Analyzing constraints and optimization objectives
- Debugging MiniZinc models"""

        if self.current_context:
            base_msg += "\n\nCurrent problem context:\n"

            if 'input_json' in self.current_context:
                input_data = self.current_context['input_json']
                if isinstance(input_data, dict):
                    if 'description' in input_data:
                        base_msg += f"\nProblem Description: {input_data['description']}\n"
                    if 'metadata' in input_data:
                        meta = input_data['metadata']
                        base_msg += f"Problem Name: {meta.get('name', 'N/A')}\n"
                        base_msg += f"Domain: {meta.get('domain', 'N/A')}\n"
                        base_msg += f"Objective: {meta.get('objective', 'N/A')}\n"

            if self.current_context.get('data_dzn'):
                base_msg += f"\nCurrent data.dzn:\n{self.current_context['data_dzn'][:300]}...\n"

            if self.current_context.get('model_mzn'):
                base_msg += f"\nCurrent model.mzn:\n{self.current_context['model_mzn'][:500]}...\n"

        return base_msg

    def clear_history(self):
        """Clear conversation history"""
        self.conversation_history = []


def create_json_viewer(json_data: dict) -> ft.Column:
    """Create a formatted view of JSON data"""
    if not isinstance(json_data, dict):
        return ft.Column([ft.Text("Invalid JSON data", color=ft.colors.RED, size=14)])

    sections = []

    if 'metadata' in json_data:
        metadata = json_data['metadata']
        metadata_items = [
            ft.Row([
                ft.Icon(ft.icons.LABEL, size=18, color=ft.colors.BLUE),
                ft.Text("Name:", weight=ft.FontWeight.BOLD, size=14),
                ft.Text(str(metadata.get('name', 'N/A')), size=14),
            ], spacing=8),
            ft.Row([
                ft.Icon(ft.icons.DOMAIN, size=18, color=ft.colors.BLUE),
                ft.Text("Domain:", weight=ft.FontWeight.BOLD, size=14),
                ft.Text(str(metadata.get('domain', 'N/A')), size=14),
            ], spacing=8),
            ft.Row([
                ft.Icon(ft.icons.FLAG, size=18, color=ft.colors.BLUE),
                ft.Text("Objective:", weight=ft.FontWeight.BOLD, size=14),
                ft.Text(str(metadata.get('objective', 'N/A')), size=14),
            ], spacing=8),
        ]

        if 'source' in metadata:
            metadata_items.append(
                ft.Row([
                    ft.Icon(ft.icons.SOURCE, size=18, color=ft.colors.BLUE),
                    ft.Text("Source:", weight=ft.FontWeight.BOLD, size=14),
                    ft.Text(str(metadata.get('source', 'N/A')), size=14),
                ], spacing=8))

        if 'identifier' in metadata:
            metadata_items.append(
                ft.Row([
                    ft.Icon(ft.icons.TAG, size=18, color=ft.colors.BLUE),
                    ft.Text("Identifier:", weight=ft.FontWeight.BOLD, size=14),
                    ft.Text(str(metadata.get('identifier', 'N/A')), size=14),
                ], spacing=8))

        if 'constraints' in metadata and isinstance(metadata['constraints'], list):
            constraints_text = ", ".join(metadata['constraints'])
            metadata_items.append(
                ft.Row([
                    ft.Icon(ft.icons.RULE, size=18, color=ft.colors.BLUE),
                    ft.Text("Constraints:", weight=ft.FontWeight.BOLD, size=14),
                    ft.Text(constraints_text, size=14),
                ], spacing=8))

        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text("Metadata", size=16, weight=ft.FontWeight.BOLD, color=ft.colors.BLUE_900),
                    ft.Divider(height=1, color=ft.colors.BLUE_200),
                    ft.Column(metadata_items, spacing=8),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.BLUE_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.BLUE_200),
            ))

    if 'description' in json_data:
        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text("Problem Description", size=16, weight=ft.FontWeight.BOLD, color=ft.colors.GREEN_900),
                    ft.Divider(height=1, color=ft.colors.GREEN_200),
                    ft.Text(str(json_data['description']), size=13),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.GREEN_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.GREEN_200),
            ))

    if 'parameters' in json_data and isinstance(json_data['parameters'], list):
        param_widgets = []
        for i, param in enumerate(json_data['parameters'], 1):
            shape_str = str(param.get('shape', [])) if param.get('shape') else "scalar"
            param_widgets.append(
                ft.Container(
                    content=ft.Column([
                        ft.Row([
                            ft.Text(f"{i}.", size=13, color=ft.colors.GREY_600),
                            ft.Text(f"{param.get('symbol', 'unknown')}", weight=ft.FontWeight.BOLD,
                                    size=14, color=ft.colors.INDIGO_900),
                            ft.Text(f"(shape: {shape_str})", size=12, color=ft.colors.GREY_600, italic=True),
                        ], spacing=6),
                        ft.Text(f"{param.get('definition', '')}", size=13, color=ft.colors.GREY_800),
                    ], spacing=4),
                    padding=8,
                    bgcolor=ft.colors.WHITE,
                    border_radius=5,
                    border=ft.border.all(1, ft.colors.GREY_300),
                ))

        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text(f"Input Parameters ({len(json_data['parameters'])})", size=16,
                            weight=ft.FontWeight.BOLD, color=ft.colors.INDIGO_900),
                    ft.Divider(height=1, color=ft.colors.INDIGO_200),
                    ft.Column(param_widgets, spacing=8),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.INDIGO_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.INDIGO_200),
            ))

    if 'output' in json_data and isinstance(json_data['output'], list):
        output_widgets = []
        for i, output in enumerate(json_data['output'], 1):
            shape_str = str(output.get('shape', [])) if output.get('shape') else "scalar"
            output_widgets.append(
                ft.Container(
                    content=ft.Column([
                        ft.Row([
                            ft.Text(f"{i}.", size=13, color=ft.colors.GREY_600),
                            ft.Text(f"{output.get('symbol', 'unknown')}", weight=ft.FontWeight.BOLD,
                                    size=14, color=ft.colors.ORANGE_900),
                            ft.Text(f"(shape: {shape_str})", size=12, color=ft.colors.GREY_600, italic=True),
                        ], spacing=6),
                        ft.Text(f"{output.get('definition', '')}", size=13, color=ft.colors.GREY_800),
                    ], spacing=4),
                    padding=8,
                    bgcolor=ft.colors.WHITE,
                    border_radius=5,
                    border=ft.border.all(1, ft.colors.GREY_300),
                ))

        sections.append(
            ft.Container(
                content=ft.Column([
                    ft.Text(f"Output Variables ({len(json_data['output'])})", size=16,
                            weight=ft.FontWeight.BOLD, color=ft.colors.ORANGE_900),
                    ft.Divider(height=1, color=ft.colors.ORANGE_200),
                    ft.Column(output_widgets, spacing=8),
                ], spacing=8),
                padding=12,
                bgcolor=ft.colors.ORANGE_50,
                border_radius=8,
                border=ft.border.all(2, ft.colors.ORANGE_200),
            ))

    return ft.Column(sections, spacing=12, scroll=ft.ScrollMode.AUTO)


def main(page: ft.Page, dataset_path: Optional[str] = None):
    page.title = "Text2Zinc Dataset Editor"
    page.theme_mode = ft.ThemeMode.LIGHT
    page.padding = 10
    page.window_min_width = 800
    page.window_min_height = 600
    page.window_resizable = True
    page.window_maximized = True

    editor = Text2ZincEditor()
    chat_assistant = ChatAssistant()

    # Status and info displays
    status_text = ft.Text("Loading dataset...", size=13, color=ft.colors.BLUE_700)
    problem_info = ft.Text("", size=11, color=ft.colors.GREY_700)
    current_index_text = ft.Text("0 / 0", size=14, weight=ft.FontWeight.BOLD)
    save_indicator = ft.Text("", size=12)
    file_loaded_info = ft.Text("", size=11, color=ft.colors.GREY_600, italic=True)

    # Input fields for editing
    input_json_field = ft.TextField(
        label="Input JSON (edit mode)", multiline=True, min_lines=15, max_lines=20, visible=False,
    )

    json_viewer_container = ft.Container(content=ft.Text("No data loaded", size=14), expand=True)

    data_dzn_field = ft.TextField(
        label="data.dzn", multiline=True, min_lines=15, max_lines=20,
        hint_text="Enter MiniZinc data file content here...",
    )

    model_mzn_field = ft.TextField(
        label="model.mzn", multiline=True, min_lines=15, max_lines=20,
        hint_text="MiniZinc model code...",
    )

    output_json_field = ft.TextField(
        label="Expected Output (output.json)", multiline=True, min_lines=8, max_lines=12,
        hint_text="Expected output in JSON format...", text_size=13,
    )

    execution_output = ft.TextField(
        label="Execution Output (Raw)", multiline=True, min_lines=8, max_lines=12,
        read_only=True, bgcolor=ft.colors.GREY_50, text_size=13,
    )

    execution_json_display = ft.Container(
        content=ft.Text("No execution yet", size=13, color=ft.colors.GREY_600),
        padding=10, border=ft.border.all(1, ft.colors.GREY_300), border_radius=5, bgcolor=ft.colors.WHITE,
    )

    problem_type_warning = ft.Container(
        visible=False,
        content=ft.Row([
            ft.Icon(ft.icons.WARNING_AMBER, color=ft.colors.ORANGE_700, size=20),
            ft.Text(
                "Satisfaction problems require manual verification. Check data.dzn, model.mzn, and output.json carefully.",
                size=12, color=ft.colors.ORANGE_900, weight=ft.FontWeight.BOLD,
            ),
        ], spacing=10),
        padding=10, bgcolor=ft.colors.ORANGE_50, border=ft.border.all(2, ft.colors.ORANGE_300), border_radius=5,
    )

    is_verified_checkbox = ft.Checkbox(label="Problem is verified", value=False)

    solver_dropdown = ft.Dropdown(
        label="Solver", width=200, value="highs",
        options=[ft.dropdown.Option("chuffed", "Chuffed"), ft.dropdown.Option("highs", "HiGHS")],
        hint_text="Select MiniZinc solver",
    )

    timeout_field = ft.TextField(
        label="Timeout (seconds)", width=150, value="60",
        keyboard_type=ft.KeyboardType.NUMBER, hint_text="Execution timeout",
    )

    chat_history_column = ft.Column(scroll=ft.ScrollMode.AUTO, spacing=10, expand=True)

    chat_input = ft.TextField(
        label="Ask AI Assistant...", multiline=True, min_lines=2, max_lines=4,
        hint_text="e.g., 'Rephrase the problem description', 'Generate a .dzn file', 'Help me write MiniZinc code'",
        expand=True,
    )

    api_key_field = ft.TextField(label="OpenAI API Key", password=True, hint_text="sk-...", expand=True)

    # Filter state — source filter driven from dataset metadata
    filter_state = {"source": "All"}
    filtered_indices = []   # global indices into editor.data matching the current filter
    filtered_pos = [0]      # position within filtered_indices

    def load_current_problem():
        """Load current problem into UI fields"""
        if not editor.data or not filtered_indices:
            return

        item = editor.get_current_item()

        current_index_text.value = f"{filtered_pos[0] + 1} / {len(filtered_indices)}"

        if isinstance(item.get('input.json'), dict):
            input_json = item['input.json']
            metadata = input_json.get('metadata', {})
            problem_info.value = f"ID: {item.get('id', 'N/A')} | {metadata.get('name', 'N/A')} | {metadata.get('domain', 'N/A')}"
        else:
            problem_info.value = f"ID: {item.get('id', 'N/A')}"

        input_json_data = item.get('input.json', {})
        if isinstance(input_json_data, dict):
            json_viewer_container.content = create_json_viewer(input_json_data)
            input_json_field.value = json.dumps(input_json_data, indent=2)
        else:
            json_viewer_container.content = ft.Text("No input.json data", size=12)
            input_json_field.value = ""

        data_dzn_field.value = item.get('data.dzn', '')
        model_mzn_field.value = item.get('model.mzn', '')

        output_json_data = item.get('output.json', {})
        if isinstance(output_json_data, dict):
            output_json_field.value = json.dumps(output_json_data)
        elif isinstance(output_json_data, str):
            try:
                parsed = json.loads(output_json_data)
                output_json_field.value = json.dumps(parsed)
            except (TypeError, ValueError):
                output_json_field.value = output_json_data
        else:
            output_json_field.value = str(output_json_data)

        is_verified_checkbox.value = item.get('is_verified', False)

        model_code = item.get('model.mzn', '')
        problem_type_warning.visible = False

        update_chat_context()

        execution_output.value = ""
        execution_json_display.content = ft.Text("No execution yet", size=13, color=ft.colors.GREY_600)

        save_indicator.value = ""

        page.update()

    def rebuild_filtered_indices():
        """Rebuild filtered_indices from current source filter"""
        filtered_indices.clear()
        source = filter_state["source"]
        for i, item in enumerate(editor.data):
            if source == "All":
                filtered_indices.append(i)
            else:
                input_json = item.get('input.json', {})
                if isinstance(input_json, dict):
                    item_source = input_json.get('metadata', {}).get('source', '')
                    if item_source == source:
                        filtered_indices.append(i)

    def populate_source_dropdown():
        """Populate source dropdown from unique sources in loaded data"""
        sources = set()
        for item in editor.data:
            input_json = item.get('input.json', {})
            if isinstance(input_json, dict):
                src = input_json.get('metadata', {}).get('source', '')
                if src:
                    sources.add(src)
        source_dropdown.options = [ft.dropdown.Option("All", "All Sources")] + [
            ft.dropdown.Option(s, s) for s in sorted(sources)
        ]
        source_dropdown.value = "All"
        filter_state["source"] = "All"

    def finish_loading(label: str, ok: bool):
        """Common post-load bookkeeping shared by every load path (local file, bundled default, HuggingFace)."""
        if not ok or not editor.data:
            status_text.value = f"Failed to load dataset ({label})"
            status_text.color = ft.colors.RED
            file_loaded_info.value = ""
            page.update()
            return

        status_text.value = f"Loaded {len(editor.data)} problems"
        status_text.color = ft.colors.GREEN
        file_loaded_info.value = f"Source: {label}"
        file_loaded_info.color = ft.colors.GREY_600

        populate_source_dropdown()
        rebuild_filtered_indices()
        if filtered_indices:
            filtered_pos[0] = 0
            editor.current_index = filtered_indices[0]
        load_current_problem()
        page.update()

    def load_local_path(path: str, label: str):
        finish_loading(label, editor.load_csv(path))

    def open_csv_result(e: ft.FilePickerResultEvent):
        if e.files:
            load_local_path(e.files[0].path, e.files[0].path)

    def load_bundled_default(e):
        load_local_path(str(DEFAULT_DATASET_PATH), "bundled default dataset")

    def load_from_hf(e):
        status_text.value = "Loading from HuggingFace (skadio/text2zinc)..."
        status_text.color = ft.colors.ORANGE
        page.update()
        finish_loading(f"HuggingFace ({TEXT2ZINC_DATASET}, not yet saved locally)", editor.load_from_huggingface())

    def sync_fields_into_current_item():
        """Copy the current UI field values back into editor.data, without writing any file."""
        if not editor.data:
            return
        if input_json_field.value:
            try:
                editor.update_current_item('input.json', json.loads(input_json_field.value))
            except (TypeError, ValueError):
                pass  # Keep as-is if not valid JSON

        editor.update_current_item('data.dzn', data_dzn_field.value)
        editor.update_current_item('model.mzn', model_mzn_field.value)

        if output_json_field.value:
            try:
                editor.update_current_item('output.json', json.loads(output_json_field.value))
            except (TypeError, ValueError):
                editor.update_current_item('output.json', output_json_field.value)

        editor.update_current_item('is_verified', is_verified_checkbox.value)

    def save_current_edits(e=None):
        """Sync edits and quick-save to the working file (text2zinc_edited.csv, Ctrl+S)"""
        if not editor.data:
            return
        try:
            sync_fields_into_current_item()
            if editor.save_csv(WORKING_DATASET_PATH):
                save_indicator.value = "✓ Saved"
                save_indicator.color = ft.colors.GREEN
                status_text.value = f"Saved to {WORKING_DATASET_PATH}"
                status_text.color = ft.colors.GREEN
            else:
                save_indicator.value = "✗ Save failed"
                save_indicator.color = ft.colors.RED
                status_text.value = "Error saving CSV"
                status_text.color = ft.colors.RED
        except Exception as ex:
            save_indicator.value = f"✗ Error: {str(ex)}"
            save_indicator.color = ft.colors.RED

        page.update()

    def save_as_result(e: ft.FilePickerResultEvent):
        """Handle the native Save As dialog: export the current dataset to any chosen path"""
        if not e.path:
            return
        if not editor.data:
            status_text.value = "No data to save"
            status_text.color = ft.colors.ORANGE
            page.update()
            return

        sync_fields_into_current_item()
        if editor.save_csv(e.path):
            status_text.value = (
                f"Saved {len(editor.data)} problems to {e.path}\n"
                f'Benchmark with it via: text2model --dataset-path "{e.path}" --strategies cot --output-dir results/'
            )
            status_text.color = ft.colors.GREEN
        else:
            status_text.value = f"Error saving to {e.path}"
            status_text.color = ft.colors.RED
        page.update()

    def save_as(e):
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        save_as_dialog.save_file(
            dialog_title="Save Text2Zinc Dataset As",
            file_name=f"text2zinc_{timestamp}.csv",
            allowed_extensions=["csv"],
        )

    def execute_code(e):
        """Execute MiniZinc code"""
        if not model_mzn_field.value or not data_dzn_field.value:
            execution_output.value = "Error: Both model.mzn and data.dzn are required"
            execution_json_display.content = ft.Text("Missing required files", size=13, color=ft.colors.RED)
            page.update()
            return

        solver = solver_dropdown.value or "highs"
        try:
            timeout = int(timeout_field.value) if timeout_field.value else 60
        except ValueError:
            timeout = 60
            timeout_field.value = "60"

        status_text.value = f"Executing MiniZinc with {solver} (timeout: {timeout}s)..."
        status_text.color = ft.colors.ORANGE
        page.update()

        model_code = model_mzn_field.value
        is_satisfaction = 'solve satisfy' in model_code.lower()
        is_minimization = 'minimize' in model_code.lower()
        is_maximization = 'maximize' in model_code.lower()

        problem_type = "satisfaction" if is_satisfaction else "optimization"

        result = editor.execute_minizinc(model_mzn_field.value, data_dzn_field.value, problem_type, solver, timeout)

        if result['success']:
            execution_output.value = f"✓ Execution successful!\n\n{result['output']}"
            status_text.value = "Execution completed successfully"
            status_text.color = ft.colors.GREEN

            if result['json_output']:
                json_output = result['json_output']
                display_widgets = []

                if is_satisfaction:
                    display_widgets.append(
                        ft.Container(
                            content=ft.Row([
                                ft.Icon(ft.icons.CHECK_CIRCLE, color=ft.colors.BLUE, size=18),
                                ft.Text("Satisfaction Problem", size=14, weight=ft.FontWeight.BOLD,
                                        color=ft.colors.BLUE_900),
                            ], spacing=8),
                            padding=8, bgcolor=ft.colors.BLUE_50, border_radius=5,
                        ))
                elif is_minimization:
                    display_widgets.append(
                        ft.Container(
                            content=ft.Row([
                                ft.Icon(ft.icons.ARROW_DOWNWARD, color=ft.colors.GREEN, size=18),
                                ft.Text("Minimization Problem", size=14, weight=ft.FontWeight.BOLD,
                                        color=ft.colors.GREEN_900),
                            ], spacing=8),
                            padding=8, bgcolor=ft.colors.GREEN_50, border_radius=5,
                        ))
                elif is_maximization:
                    display_widgets.append(
                        ft.Container(
                            content=ft.Row([
                                ft.Icon(ft.icons.ARROW_UPWARD, color=ft.colors.PURPLE, size=18),
                                ft.Text("Maximization Problem", size=14, weight=ft.FontWeight.BOLD,
                                        color=ft.colors.PURPLE_900),
                            ], spacing=8),
                            padding=8, bgcolor=ft.colors.PURPLE_50, border_radius=5,
                        ))

                if '_objective' in json_output:
                    display_widgets.append(
                        ft.Container(
                            content=ft.Column([
                                ft.Text("Objective Value:", size=13, weight=ft.FontWeight.BOLD, color=ft.colors.GREY_700),
                                ft.Text(str(json_output['_objective']), size=20, weight=ft.FontWeight.BOLD,
                                        color=ft.colors.BLUE_900),
                            ], spacing=4),
                            padding=10, bgcolor=ft.colors.BLUE_50, border=ft.border.all(2, ft.colors.BLUE_300),
                            border_radius=5,
                        ))

                other_vars = {k: v for k, v in json_output.items() if k != '_objective'}
                if other_vars:
                    var_widgets = []
                    for key, value in other_vars.items():
                        var_widgets.append(
                            ft.Container(
                                content=ft.Column([
                                    ft.Text(f"{key}:", size=13, weight=ft.FontWeight.BOLD, color=ft.colors.GREY_700),
                                    ft.Text(str(value), size=12, color=ft.colors.GREY_900),
                                ], spacing=2),
                                padding=8, bgcolor=ft.colors.GREY_50, border_radius=5,
                            ))

                    display_widgets.append(
                        ft.Container(
                            content=ft.Column([
                                ft.Text("Solution Variables:", size=13, weight=ft.FontWeight.BOLD, color=ft.colors.GREY_700),
                                ft.Column(var_widgets, spacing=6),
                            ], spacing=8),
                            padding=10, border=ft.border.all(1, ft.colors.GREY_300), border_radius=5,
                        ))

                execution_json_display.content = ft.Column(display_widgets, spacing=10, scroll=ft.ScrollMode.AUTO)
            else:
                execution_json_display.content = ft.Text("No JSON output available", size=13, color=ft.colors.GREY_600)

            if output_json_field.value:
                try:
                    expected = json.loads(output_json_field.value)
                    if '_objective' in expected and '_objective' in result['json_output']:
                        expected_obj = float(expected['_objective'])
                        actual_obj = float(result['json_output']['_objective'])
                        diff = abs(expected_obj - actual_obj)

                        if diff < 1e-6:
                            comparison_text = f"✓ Matches expected objective: {expected_obj}"
                            comparison_color = ft.colors.GREEN_700
                        else:
                            comparison_text = f"✗ Expected: {expected_obj}, Got: {actual_obj} (diff: {diff:.6f})"
                            comparison_color = ft.colors.RED_700

                        execution_json_display.content.controls.append(
                            ft.Container(
                                content=ft.Text(comparison_text, size=13, weight=ft.FontWeight.BOLD, color=comparison_color),
                                padding=10,
                                bgcolor=ft.colors.GREEN_50 if diff < 1e-6 else ft.colors.RED_50,
                                border_radius=5,
                            ))
                except Exception:
                    pass  # Ignore comparison errors

        else:
            execution_output.value = f"✗ Execution failed:\n\n{result['error']}"
            status_text.value = "Execution failed"
            status_text.color = ft.colors.RED
            execution_json_display.content = ft.Container(
                content=ft.Column([
                    ft.Text("Execution Failed", size=14, weight=ft.FontWeight.BOLD, color=ft.colors.RED_900),
                    ft.Text(result['error'][:500], size=12, color=ft.colors.RED_700),
                ]),
                padding=10, bgcolor=ft.colors.RED_50, border=ft.border.all(2, ft.colors.RED_300), border_radius=5,
            )

        page.update()

    def toggle_edit_mode(e):
        """Toggle between view and edit mode for input.json"""
        if e.control.value:
            json_viewer_container.visible = False
            input_json_field.visible = True
        else:
            json_viewer_container.visible = True
            input_json_field.visible = False
        page.update()

    def navigate_previous(e):
        if filtered_indices and filtered_pos[0] > 0:
            filtered_pos[0] -= 1
            editor.current_index = filtered_indices[filtered_pos[0]]
            load_current_problem()

    def navigate_next(e):
        if filtered_indices and filtered_pos[0] < len(filtered_indices) - 1:
            filtered_pos[0] += 1
            editor.current_index = filtered_indices[filtered_pos[0]]
            load_current_problem()

    def on_field_change(e):
        save_indicator.value = "\U0001F4DD Unsaved"
        save_indicator.color = ft.colors.ORANGE_600
        page.update()

    def update_chat_context():
        item = editor.get_current_item()
        chat_assistant.update_context({
            'input_json': item.get('input.json', {}),
            'data_dzn': item.get('data.dzn', ''),
            'model_mzn': item.get('model.mzn', ''),
            'output_json': item.get('output.json', {}),
        })

    def send_chat_message(e):
        if not chat_input.value.strip():
            return

        user_message = chat_input.value.strip()

        chat_history_column.controls.append(
            ft.Container(
                content=ft.Column([
                    ft.Text("You:", weight=ft.FontWeight.BOLD, size=12),
                    ft.Text(user_message, size=11, selectable=True),
                ]),
                bgcolor=ft.colors.BLUE_50, padding=10, border_radius=8,
            ))

        chat_input.value = ""
        page.update()

        loading_container = ft.Container(
            content=ft.Row([
                ft.ProgressRing(width=16, height=16),
                ft.Text("AI is thinking...", size=11, color=ft.colors.GREY),
            ]),
            padding=10,
        )
        chat_history_column.controls.append(loading_container)
        page.update()

        ai_response = chat_assistant.send_message(user_message)

        chat_history_column.controls.remove(loading_container)

        chat_history_column.controls.append(
            ft.Container(
                content=ft.Column([
                    ft.Text("AI Assistant:", weight=ft.FontWeight.BOLD, size=12, color=ft.colors.GREEN),
                    ft.Text(ai_response, size=11, selectable=True),
                ]),
                bgcolor=ft.colors.GREEN_50, padding=10, border_radius=8,
            ))

        page.update()
        chat_history_column.scroll_to(offset=-1, duration=300)

    def clear_chat(e):
        chat_history_column.controls.clear()
        chat_assistant.clear_history()
        page.update()

    def close_chat(e):
        chat_panel.visible = False
        open_chat_button.visible = True
        page.update()

    def set_api_key(e):
        if api_key_field.value:
            chat_assistant.set_api_key(api_key_field.value)
            status_text.value = "API key set successfully"
            status_text.color = ft.colors.GREEN
        else:
            status_text.value = "Please enter an API key"
            status_text.color = ft.colors.ORANGE
        page.update()

    def go_to_problem(e):
        try:
            idx = int(goto_field.value) - 1
            if filtered_indices and 0 <= idx < len(filtered_indices):
                filtered_pos[0] = idx
                editor.current_index = filtered_indices[idx]
                load_current_problem()
            else:
                limit = len(filtered_indices) if filtered_indices else 0
                status_text.value = f"Invalid number. Must be between 1 and {limit}"
                status_text.color = ft.colors.RED
                page.update()
        except (ValueError, TypeError):
            status_text.value = "Please enter a valid number"
            status_text.color = ft.colors.RED
            page.update()

    def on_source_filter_change(e):
        filter_state["source"] = source_dropdown.value or "All"
        rebuild_filtered_indices()
        if filtered_indices:
            filtered_pos[0] = 0
            editor.current_index = filtered_indices[0]
            load_current_problem()
        else:
            current_index_text.value = "0 / 0"
            status_text.value = f"No problems found for source: {filter_state['source']}"
            status_text.color = ft.colors.ORANGE
            page.update()

    # Attach change handlers
    data_dzn_field.on_change = on_field_change
    model_mzn_field.on_change = on_field_change
    output_json_field.on_change = on_field_change
    input_json_field.on_change = on_field_change
    is_verified_checkbox.on_change = on_field_change

    # Navigation controls
    prev_button = ft.IconButton(icon=ft.icons.ARROW_BACK, on_click=navigate_previous, tooltip="Previous (Alt+←)")
    next_button = ft.IconButton(icon=ft.icons.ARROW_FORWARD, on_click=navigate_next, tooltip="Next (Alt+→)")

    goto_field = ft.TextField(label="Go to #", width=100, keyboard_type=ft.KeyboardType.NUMBER, hint_text="Problem #")
    goto_button = ft.ElevatedButton("Go", on_click=go_to_problem, width=80)

    source_dropdown = ft.Dropdown(
        label="Source", width=280, value="All", options=[ft.dropdown.Option("All", "All Sources")],
        on_change=on_source_filter_change, hint_text="Filter by source",
    )

    # Data source pickers
    open_csv_dialog = ft.FilePicker(on_result=open_csv_result)
    save_as_dialog = ft.FilePicker(on_result=save_as_result)
    page.overlay.extend([open_csv_dialog, save_as_dialog])

    open_csv_button = ft.OutlinedButton(
        "Open CSV...", icon=ft.icons.FOLDER_OPEN,
        on_click=lambda e: open_csv_dialog.pick_files(allow_multiple=False, allowed_extensions=["csv"]),
        tooltip="Open a local Text2Zinc CSV dataset",
    )

    load_hf_button = ft.OutlinedButton(
        "Load from HuggingFace", icon=ft.icons.CLOUD_DOWNLOAD, on_click=load_from_hf,
        tooltip=f"Reload fresh from the {TEXT2ZINC_DATASET} HuggingFace dataset",
    )

    save_button = ft.ElevatedButton(
        "Save", icon=ft.icons.SAVE, on_click=save_current_edits,
        bgcolor=ft.colors.BLUE_700, color=ft.colors.WHITE,
        tooltip=f"Quick-save to {WORKING_DATASET_PATH} (Ctrl+S)",
    )

    save_as_button = ft.ElevatedButton(
        "Save As New Dataset...", icon=ft.icons.SAVE_AS, on_click=save_as,
        bgcolor=ft.colors.GREEN_700, color=ft.colors.WHITE,
        tooltip="Save to a chosen path — pass it to text2model --dataset-path to benchmark against it",
    )

    execute_button = ft.ElevatedButton(
        "Execute MiniZinc", icon=ft.icons.PLAY_ARROW, on_click=execute_code,
        bgcolor=ft.colors.GREEN_700, color=ft.colors.WHITE,
    )

    edit_mode_switch = ft.Switch(label="Edit JSON", value=False, on_change=toggle_edit_mode)

    send_button = ft.IconButton(icon=ft.icons.SEND, tooltip="Send message", on_click=send_chat_message)
    clear_chat_button = ft.IconButton(icon=ft.icons.DELETE_SWEEP, tooltip="Clear chat", on_click=clear_chat)
    set_key_button = ft.ElevatedButton("Set API Key", icon=ft.icons.KEY, on_click=set_api_key)

    def open_chat(e):
        chat_panel.visible = True
        open_chat_button.visible = False
        page.update()

    open_chat_button = ft.OutlinedButton(
        "AI Assistant",
        icon=ft.icons.CHAT,
        on_click=open_chat,
    )

    # Primary work area
    tabs = ft.Tabs(
                            selected_index=0,
                            animation_duration=300,
                            tabs=[
                                ft.Tab(
                                    text="Input", icon=ft.icons.INPUT,
                                    content=ft.Container(
                                        content=ft.Column([
                                            ft.Row([
                                                ft.Text("Problem Specification (input.json)", size=14,
                                                        weight=ft.FontWeight.BOLD),
                                                edit_mode_switch,
                                            ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                                            ft.Divider(height=1),
                                            json_viewer_container,
                                            input_json_field,
                                        ], scroll=ft.ScrollMode.AUTO),
                                        padding=10,
                                    ),
                                ),
                                ft.Tab(
                                    text="Data", icon=ft.icons.STORAGE,
                                    content=ft.Container(
                                        content=ft.Column([
                                            ft.Text("Data File (data.dzn)", size=14, weight=ft.FontWeight.BOLD),
                                            ft.Divider(height=1),
                                            data_dzn_field,
                                        ], scroll=ft.ScrollMode.AUTO),
                                        padding=10,
                                    ),
                                ),
                                ft.Tab(
                                    text="Model", icon=ft.icons.CODE,
                                    content=ft.Container(
                                        content=ft.Column([
                                            ft.Text("MiniZinc Model (model.mzn)", size=14, weight=ft.FontWeight.BOLD),
                                            ft.Divider(height=1),
                                            model_mzn_field,
                                        ], scroll=ft.ScrollMode.AUTO),
                                        padding=10,
                                    ),
                                ),
                                ft.Tab(
                                    text="Execute", icon=ft.icons.PLAY_CIRCLE,
                                    content=ft.Container(
                                        content=ft.Column([
                                            ft.Text("Output & Execution", size=14, weight=ft.FontWeight.BOLD),
                                            ft.Divider(height=1),
                                            problem_type_warning,
                                            output_json_field,
                                            ft.Container(height=10),
                                            ft.Row([is_verified_checkbox]),
                                            ft.Container(height=10),
                                            ft.Text("Execution Settings:", size=13, weight=ft.FontWeight.BOLD),
                                            ft.Row([solver_dropdown, timeout_field], spacing=15),
                                            ft.Container(height=10),
                                            ft.Row([execute_button], spacing=10),
                                            ft.Container(height=15),
                                            ft.Text("Execution Results (Formatted):", size=14, weight=ft.FontWeight.BOLD),
                                            ft.Divider(height=1),
                                            execution_json_display,
                                            ft.Container(height=10),
                                            ft.Text("Raw Output:", size=13, weight=ft.FontWeight.BOLD),
                                            execution_output,
                                        ], scroll=ft.ScrollMode.AUTO),
                                        padding=10,
                                    ),
                                ),
                            ],
                    expand=True,
                )

    problem_navigation = ft.Row(
        [
            prev_button,
            current_index_text,
            next_button,
            goto_field,
            goto_button,
            open_chat_button,
        ],
        spacing=8,
        vertical_alignment=ft.CrossAxisAlignment.CENTER,
    )

    dataset_controls = ft.Column(
        [
            status_text,
            file_loaded_info,
            problem_info,
            save_indicator,
            ft.Divider(height=1),
            open_csv_button,
            load_hf_button,
            save_button,
            save_as_button,
            source_dropdown,
        ],
        spacing=10,
    )

    def toggle_dataset_sidebar(e):
        if dataset_sidebar.width == 48:
            dataset_sidebar.width = 300
            dataset_sidebar.content = ft.Column(
                [
                    ft.Row(
                        [
                            ft.Row(
                                [
                                    ft.Icon(ft.icons.TUNE, color=ft.colors.BLUE),
                                    ft.Text("Dataset controls", weight=ft.FontWeight.BOLD),
                                ],
                                spacing=8,
                            ),
                            ft.IconButton(
                                icon=ft.icons.CHEVRON_LEFT,
                                tooltip="Hide dataset controls",
                                on_click=toggle_dataset_sidebar,
                            ),
                        ],
                        alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                    ),
                    dataset_controls,
                ],
                spacing=10,
            )
        else:
            dataset_sidebar.width = 48
            dataset_sidebar.content = ft.IconButton(
                icon=ft.icons.TUNE,
                tooltip="Show dataset controls",
                on_click=toggle_dataset_sidebar,
            )
        page.update()

    dataset_sidebar = ft.Container(
        content=ft.IconButton(
            icon=ft.icons.TUNE,
            tooltip="Show dataset controls",
            on_click=toggle_dataset_sidebar,
        ),
        width=48,
        animate_size=ft.animation.Animation(200, ft.AnimationCurve.EASE_IN_OUT),
        bgcolor=ft.colors.GREY_100,
        border_radius=8,
        padding=4,
    )

    tab_area = ft.Stack(
        [
            tabs,
            ft.Container(
                content=problem_navigation,
                top=0,
                right=0,
                padding=ft.padding.only(top=4, right=8),
                bgcolor=ft.colors.WHITE,
            ),
        ],
        expand=True,
    )

    # Layout
    main_content = ft.Container(
        content=ft.Column(
            [
                ft.Row(
                    [dataset_sidebar, tab_area],
                    expand=True,
                    spacing=12,
                    vertical_alignment=ft.CrossAxisAlignment.START,
                ),
            ],
            expand=True,
        ),
        expand=True,
    )

    chat_panel = ft.Container(
        content=ft.Column(
            [
                ft.Row(
                    [
                        ft.Row(
                            [
                                ft.Icon(ft.icons.CHAT, color=ft.colors.BLUE),
                                ft.Text("AI Assistant", size=18, weight=ft.FontWeight.BOLD),
                            ],
                            spacing=8,
                        ),
                        ft.IconButton(
                            icon=ft.icons.CLOSE,
                            tooltip="Hide AI Assistant",
                            on_click=close_chat,
                        ),
                    ],
                    alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                ),
                ft.Text(
                    "Get help with problem descriptions, code generation, and more",
                    size=11,
                    color=ft.colors.GREY_700,
                ),
                ft.Divider(height=1),
                ft.Row([api_key_field, set_key_button], spacing=10),
                ft.Container(
                    content=chat_history_column,
                    expand=True,
                    padding=10,
                    border=ft.border.all(1, ft.colors.GREY_300),
                    border_radius=8,
                ),
                ft.Row(
                    [
                        chat_input,
                        ft.Column([send_button, clear_chat_button], spacing=5),
                    ],
                    spacing=10,
                ),
            ],
            expand=True,
        ),
        width=420,
        visible=False,
        border=ft.border.all(1, ft.colors.BLUE_200),
        border_radius=10,
        padding=10,
    )
    page.add(
        ft.Row(
            [main_content, chat_panel],
            expand=True,
            spacing=16,
            vertical_alignment=ft.CrossAxisAlignment.START,
        )
    )

    # Keyboard shortcuts
    def handle_keyboard(e: ft.KeyboardEvent):
        if e.ctrl and e.key == "S":
            e.prevent_default = True
            save_current_edits()
        elif e.ctrl and e.key == "Enter":
            execute_code(None)
        elif e.key == "Arrow Left" and e.alt:
            navigate_previous(None)
        elif e.key == "Arrow Right" and e.alt:
            navigate_next(None)

    page.on_keyboard_event = handle_keyboard

    # Initial load — local-first: an explicit --dataset-path, then a previous
    # editing session, then the bundled default. HuggingFace is opt-in only
    # (via the "Load from HuggingFace" button), never the editor's default.
    if dataset_path and os.path.exists(dataset_path):
        load_local_path(dataset_path, dataset_path)
    elif os.path.exists(WORKING_DATASET_PATH):
        load_local_path(WORKING_DATASET_PATH, f"previous session ({WORKING_DATASET_PATH})")
    elif DEFAULT_DATASET_PATH.exists():
        load_local_path(str(DEFAULT_DATASET_PATH), "bundled default dataset")
    else:
        status_text.value = "No dataset found. Use 'Open CSV...' or 'Load from HuggingFace' to get started."
        status_text.color = ft.colors.ORANGE
        page.update()


def launch(dataset_path: Optional[str] = None) -> None:
    """Launch the Text2Zinc dataset editor GUI."""
    ft.app(target=lambda page: main(page, dataset_path=dataset_path))


if __name__ == "__main__":
    launch()
