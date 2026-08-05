import datetime
import json
import os
import tempfile
from typing import List, Optional

import flet as ft

from text2model.editor.chat_assistant import DEFAULT_CHAT_MODEL, ChatAssistant
from text2model.editor.dataset_editor import Text2ZincEditor, blank_problem, validate_item
from text2model.editor.json_viewer import create_json_viewer
from text2model.utils import (
    OPENAI_MODELS,
    TEXT2ZINC_DATASET,
    check_hf_token_for_text2zinc,
    verify_minizinc_solution,
)

# Where quick-save (the "Save" button / Ctrl+S) writes to, in the current
# working directory. "Save As..." lets the user pick any other destination —
# that destination is the "new text2zinc dataset" to pass to
# `text2model --text2zinc-path` / `evals/evaluate.py --text2zinc-path`.
WORKING_DATASET_PATH = "text2zinc_edited.csv"

# HF mode: for deploying the editor as a read-mostly demo in a HuggingFace
# Space, set T2M_HF_MODE=1. There's no HuggingFace Hub write token in the
# container, so it never pushes back to the Hub: it only ever works with a
# CSV already baked into the image/pushed alongside it (or, absent that,
# whatever it pulls read-only from the public `skadio/text2zinc` dataset on
# startup). In this mode:
#   - "Load from CSV" and "Save As..." are hidden — there is exactly one
#     dataset, and no arbitrary filesystem/Hub access. "Load from
#     HuggingFace" stays visible in both modes: it's the only way to refresh
#     a Space's data without a full rebuild/restart, and it always
#     force-downloads (bypassing the local `datasets` cache) so it actually
#     picks up upstream dataset updates.
#   - Quick-save (Save button / Ctrl+S) still works, but writes in place to
#     that same pushed file instead of a separate WORKING_DATASET_PATH.
# T2M_EDITOR_DATASET_PATH points at the pushed CSV to load on startup; falls
# back to loading fresh from HuggingFace if unset.
#
# Concurrency caveat: a Space is a single shared container. If more than one
# person has it open at once, quick-save writes from different sessions can
# race and clobber each other — there's no per-session file or locking here.
# Don't rely on this mode for concurrent multi-user editing; see
# `save_current_edits()` below for exactly what it writes and when.
HF_MODE = os.environ.get("T2M_HF_MODE", "").strip().lower() in ("1", "true", "yes")
HF_MODE_DATASET_PATH = os.environ.get("T2M_EDITOR_DATASET_PATH")


def main(page: ft.Page, text2zinc_path: Optional[str] = None):
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
        multiline=True, min_lines=8, max_lines=12,
        hint_text="Expected output in JSON format...", text_size=13,
    )

    execution_output = ft.TextField(
        multiline=True, min_lines=8, max_lines=12,
        read_only=True, bgcolor=ft.colors.GREY_50, text_size=13,
    )

    execution_json_display = ft.Container(
        content=ft.Text("No execution yet", size=13, color=ft.colors.GREY_600),
        padding=10, border=ft.border.all(1, ft.colors.GREY_300), border_radius=8, bgcolor=ft.colors.WHITE,
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
    chat_model_dropdown = ft.Dropdown(
        label="Model", width=140, value=DEFAULT_CHAT_MODEL,
        options=[ft.dropdown.Option(m) for m in OPENAI_MODELS],
    )

    # Filter state — source filter driven from dataset metadata
    filter_state = {"source": "All"}
    filtered_indices = []   # global indices into editor.data matching the current filter
    filtered_pos = [0]      # position within filtered_indices

    # Tracks an in-progress "New Problem" so it can be discarded via Cancel:
    # the global index of the not-yet-saved blank item, where to jump back to,
    # and what edit-mode state to restore.
    pending_new_problem = {"index": None, "return_index": None, "was_edit_mode": False}

    # Whichever local path is currently loaded — in HF mode, quick-save
    # writes back here in place instead of to WORKING_DATASET_PATH.
    loaded_dataset_path = [WORKING_DATASET_PATH]

    def load_current_problem():
        """Load current problem into UI fields"""
        if not editor.data or not filtered_indices:
            return

        # Cancel only makes sense right after "New Problem", while still
        # looking at that blank item — once the user navigates elsewhere it
        # becomes just another (unsaved) row.
        if pending_new_problem["index"] is not None and editor.current_index != pending_new_problem["index"]:
            pending_new_problem["index"] = None
            pending_new_problem["return_index"] = None
            new_problem_button.visible = True
            cancel_new_problem_button.visible = False

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
        """Common post-load bookkeeping shared by every load path (local file, HuggingFace)."""
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
        loaded_dataset_path[0] = path
        finish_loading(label, editor.load_csv(path))

    def open_csv_result(e: ft.FilePickerResultEvent):
        if e.files:
            load_local_path(e.files[0].path, e.files[0].path)

    def load_from_hf(e):
        """Load the latest TEXT2ZINC_DATASET from HuggingFace, always forcing
        a fresh download (bypassing the local `datasets` cache) so upstream
        dataset updates show up even though a cached copy already exists
        (e.g. baked into a HF Space image)."""
        status_text.value = f"Loading the latest {TEXT2ZINC_DATASET} from HuggingFace (forcing fresh download)..."
        status_text.color = ft.colors.ORANGE
        page.update()
        try:
            check_hf_token_for_text2zinc(force_download=True)
        except RuntimeError as ex:
            status_text.value = str(ex)
            status_text.color = ft.colors.RED
            page.update()
            return
        finish_loading(
            f"HuggingFace ({TEXT2ZINC_DATASET}, freshly downloaded)",
            editor.load_from_huggingface(force_download=True),
        )

    def generate_unique_identifier() -> str:
        existing = set()
        for it in editor.data:
            ij = it.get('input.json', {})
            if isinstance(ij, dict):
                ident = ij.get('metadata', {}).get('identifier')
                if ident:
                    existing.add(ident)
        n = 1
        while f"new_problem_{n}" in existing:
            n += 1
        return f"new_problem_{n}"

    def new_problem(e):
        """Add a blank problem, matching the same schema as every other row,
        and jump straight to it in edit mode so it's ready to fill in."""
        pending_new_problem["return_index"] = editor.current_index if editor.data and filtered_indices else None
        pending_new_problem["was_edit_mode"] = edit_mode_switch.value

        editor.data.append(blank_problem(generate_unique_identifier()))

        # The new item has no source yet, so make sure it's visible regardless
        # of whatever source filter is currently active.
        if filter_state["source"] != "All":
            filter_state["source"] = "All"
            source_dropdown.value = "All"

        rebuild_filtered_indices()
        new_global_index = len(editor.data) - 1
        pending_new_problem["index"] = new_global_index
        filtered_pos[0] = filtered_indices.index(new_global_index)
        editor.current_index = new_global_index
        load_current_problem()

        # Land on the Input tab, in edit mode, ready to type.
        tabs.selected_index = 0
        edit_mode_switch.value = True
        json_viewer_container.visible = False
        input_json_field.visible = True

        new_problem_button.visible = False
        cancel_new_problem_button.visible = True

        status_text.value = (
            "New problem added — fill in description, source, and either "
            "model.mzn or an objective before saving."
        )
        status_text.color = ft.colors.BLUE
        page.update()

    def cancel_new_problem(e):
        """Changed their mind: discard the not-yet-saved blank problem and
        jump back to whatever problem they were on before."""
        new_index = pending_new_problem["index"]
        if new_index is None or new_index >= len(editor.data):
            return

        del editor.data[new_index]
        return_index = pending_new_problem["return_index"]
        was_edit_mode = pending_new_problem["was_edit_mode"]
        pending_new_problem["index"] = None
        pending_new_problem["return_index"] = None

        rebuild_filtered_indices()
        if filtered_indices:
            if return_index is not None and return_index in filtered_indices:
                filtered_pos[0] = filtered_indices.index(return_index)
            else:
                filtered_pos[0] = min(filtered_pos[0], len(filtered_indices) - 1)
            editor.current_index = filtered_indices[filtered_pos[0]]
            load_current_problem()
        else:
            current_index_text.value = "0 / 0"
            problem_info.value = ""
            json_viewer_container.content = ft.Text("No data loaded", size=14)

        edit_mode_switch.value = was_edit_mode
        json_viewer_container.visible = not was_edit_mode
        input_json_field.visible = was_edit_mode

        cancel_new_problem_button.visible = False
        new_problem_button.visible = True

        status_text.value = "New problem discarded."
        status_text.color = ft.colors.GREY_700
        page.update()

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
        """Sync edits and quick-save (Ctrl+S). Normal mode writes to the
        working file (text2zinc_edited.csv), kept separate from whatever was
        opened so the original is never silently overwritten. HF mode writes
        in place to the single pushed dataset file instead, since there's no
        separate export step in a Space — note that this file is shared by
        every concurrent visitor to the Space, so quick-saves from different
        sessions can race and clobber each other (see the HF mode note near
        HF_MODE above)."""
        if not editor.data:
            return
        save_target = loaded_dataset_path[0] if HF_MODE else WORKING_DATASET_PATH
        try:
            sync_fields_into_current_item()
            if editor.save_csv(save_target):
                save_indicator.value = "✓ Saved"
                save_indicator.color = ft.colors.GREEN
                status_text.value = f"Saved to {save_target}"
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

    def copy_csv(e=None):
        """Copy the current dataset, as CSV text, to the clipboard.

        HF mode only: the container's filesystem (where quick-save
        writes) isn't reachable from the HF Space UI, and there's no HF Hub
        token to push edits anywhere else. Browser file downloads are also
        blocked in the HF Space iframe, so instead of downloading a file we
        put the CSV text on the clipboard and let the user paste it into a
        file themselves."""
        if not editor.data:
            status_text.value = "No data to copy"
            status_text.color = ft.colors.ORANGE
            page.update()
            return

        sync_fields_into_current_item()
        tmp_path = tempfile.mktemp(suffix=".csv")
        try:
            if not editor.save_csv(tmp_path):
                raise RuntimeError("save_csv failed")
            with open(tmp_path, "r", encoding="utf-8") as f:
                csv_text = f.read()
        except Exception as ex:
            status_text.value = f"Error preparing CSV: {ex}"
            status_text.color = ft.colors.RED
            page.update()
            return
        finally:
            if os.path.exists(tmp_path):
                os.remove(tmp_path)

        page.set_clipboard(csv_text)
        status_text.value = f"Copied {len(editor.data)} problems as CSV to clipboard"
        status_text.color = ft.colors.GREEN
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
                f'Benchmark with it via: text2model --text2zinc-path "{e.path}" --strategies cot --output-dir results/'
            )
            status_text.color = ft.colors.GREEN
            if not str(data_dzn_field.value or '').strip():
                status_text.value += (
                    "\nNote: current problem has no data.dzn — fine if the model has data built in, "
                    "otherwise add one."
                )
        else:
            status_text.value = f"Error saving to {e.path}"
            status_text.color = ft.colors.RED
        page.update()

    def close_validation_dialog(e):
        validation_dialog.open = False
        page.update()

    validation_dialog = ft.AlertDialog(
        modal=True,
        title=ft.Row([
            ft.Icon(ft.icons.ERROR_OUTLINE, color=ft.colors.RED),
            ft.Text("Can't save — missing required fields"),
        ], spacing=8),
        content=ft.Text(""),
        actions=[ft.TextButton("OK", on_click=close_validation_dialog)],
    )
    page.overlay.append(validation_dialog)

    def show_validation_dialog(missing: List[str]):
        validation_dialog.content = ft.Column(
            [ft.Text("This problem is missing:", size=13)]
            + [ft.Text(f"• {m}", size=13) for m in missing],
            tight=True, spacing=6,
        )
        validation_dialog.open = True
        page.update()

    def save_as(e):
        if not editor.data:
            status_text.value = "No data to save"
            status_text.color = ft.colors.ORANGE
            page.update()
            return

        sync_fields_into_current_item()
        missing = validate_item(editor.get_current_item())
        if missing:
            show_validation_dialog(missing)
            return

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
                comparison_text = None
                try:
                    _, solution_success, verify_output = verify_minizinc_solution(
                        model_code, data_dzn_field.value, output_json_field.value,
                        problem_type, timeout=timeout, solver=solver,
                    )

                    if is_satisfaction:
                        if solution_success:
                            comparison_text = "✓ Solution satisfies the model's constraints"
                        else:
                            comparison_text = f"✗ Solution does not satisfy the constraints: {verify_output[:300]}"
                    else:
                        expected = json.loads(output_json_field.value)
                        if '_objective' in expected:
                            expected_obj = float(expected['_objective'])
                            if solution_success:
                                comparison_text = f"✓ Matches expected objective: {expected_obj}"
                            else:
                                comparison_text = f"✗ Expected: {expected_obj}, Got: {verify_output}"

                    if comparison_text:
                        comparison_color = ft.colors.GREEN_700 if solution_success else ft.colors.RED_700
                        execution_json_display.content.controls.append(
                            ft.Container(
                                content=ft.Text(comparison_text, size=13, weight=ft.FontWeight.BOLD, color=comparison_color),
                                padding=10,
                                bgcolor=ft.colors.GREEN_50 if solution_success else ft.colors.RED_50,
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

    def set_chat_model(e):
        if chat_model_dropdown.value:
            chat_assistant.set_model(chat_model_dropdown.value)

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
        "Load from CSV", icon=ft.icons.FOLDER_OPEN,
        on_click=lambda e: open_csv_dialog.pick_files(allow_multiple=False, allowed_extensions=["csv"]),
        tooltip="Open a local Text2Zinc CSV dataset",
        visible=not HF_MODE,
    )

    load_hf_button = ft.OutlinedButton(
        "Load from HuggingFace", icon=ft.icons.CLOUD_DOWNLOAD, on_click=load_from_hf,
        tooltip=(f"Force a fresh download of {TEXT2ZINC_DATASET} from HuggingFace, bypassing the "
                 "local cache, to sync with the latest upstream dataset. Click Save afterward to "
                 "persist it." if HF_MODE else
                 f"Force a fresh download of {TEXT2ZINC_DATASET} from HuggingFace, bypassing the local cache"),
    )

    new_problem_button = ft.ElevatedButton(
        "New Problem", icon=ft.icons.ADD, on_click=new_problem,
        bgcolor=ft.colors.PURPLE_700, color=ft.colors.WHITE,
        tooltip="Add a blank problem with the same schema, ready to edit",
    )

    cancel_new_problem_button = ft.OutlinedButton(
        "Cancel New Problem", icon=ft.icons.CLOSE, on_click=cancel_new_problem,
        visible=False,
        tooltip="Discard this blank problem and go back to the previous one",
    )

    save_button = ft.ElevatedButton(
        "Save", icon=ft.icons.SAVE, on_click=save_current_edits,
        bgcolor=ft.colors.BLUE_700, color=ft.colors.WHITE,
        tooltip=("Quick-save in place (Ctrl+S) — shared by everyone using this Space right now, "
                 "so concurrent saves aren't guaranteed to be consistent" if HF_MODE
                 else f"Quick-save to {WORKING_DATASET_PATH} (Ctrl+S)"),
    )

    save_as_button = ft.ElevatedButton(
        "Save As New Dataset...", icon=ft.icons.SAVE_AS, on_click=save_as,
        bgcolor=ft.colors.GREEN_700, color=ft.colors.WHITE,
        tooltip="Save to a chosen path — pass it to text2model --text2zinc-path to benchmark against it",
        visible=not HF_MODE,
    )

    copy_button = ft.ElevatedButton(
        "Copy CSV", icon=ft.icons.COPY, on_click=copy_csv,
        bgcolor=ft.colors.GREEN_700, color=ft.colors.WHITE,
        tooltip="Copy the current dataset as CSV text to your clipboard",
        visible=HF_MODE,
    )

    execute_button = ft.ElevatedButton(
        "Execute MiniZinc", icon=ft.icons.PLAY_ARROW, on_click=execute_code,
        bgcolor=ft.colors.GREEN_700, color=ft.colors.WHITE,
    )

    edit_mode_switch = ft.Switch(label="Edit JSON", value=False, on_change=toggle_edit_mode)

    send_button = ft.IconButton(icon=ft.icons.SEND, tooltip="Send message", on_click=send_chat_message)
    clear_chat_button = ft.IconButton(icon=ft.icons.DELETE_SWEEP, tooltip="Clear chat", on_click=clear_chat)
    set_key_button = ft.ElevatedButton("Set API Key", icon=ft.icons.KEY, on_click=set_api_key)
    chat_model_dropdown.on_change = set_chat_model

    def open_chat(e):
        chat_panel.visible = True
        open_chat_button.visible = False
        page.update()

    open_chat_button = ft.OutlinedButton(
        "AI Assistant",
        icon=ft.icons.CHAT,
        on_click=open_chat,
    )

    def labeled_box(title: str, content: ft.Control, height: Optional[int] = None) -> ft.Container:
        """Uniform bordered panel used for the Execute tab's output boxes, so
        Raw Output / Expected Output / Execution Results all read as one
        family of boxes regardless of the widget they wrap.

        No expand=True here: these boxes live inside a scrollable Column,
        which gives its children unbounded height, and flet/flutter crashes
        (invalid transform matrix) if something under it tries to expand
        into that unbounded space. Passing a fixed `height` is the safe way
        to make a box (e.g. the results panel) span roughly the same space
        as its neighbors.
        """
        return ft.Container(
            content=ft.Column([
                ft.Text(title, size=13, weight=ft.FontWeight.BOLD, color=ft.colors.GREY_700),
                content,
            ], spacing=6),
            padding=10, border=ft.border.all(1, ft.colors.GREY_300), border_radius=8,
            bgcolor=ft.colors.WHITE, height=height,
        )

    raw_output_box = labeled_box("Raw Output", execution_output)
    expected_output_box = labeled_box("Expected Output (output.json)", output_json_field)
    execution_results_box = labeled_box("Execution Results (Formatted)", execution_json_display, height=470)

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
                                            ft.Row(
                                                [execute_button, solver_dropdown, timeout_field, is_verified_checkbox],
                                                spacing=15, vertical_alignment=ft.CrossAxisAlignment.CENTER,
                                            ),
                                            problem_type_warning,
                                            ft.Container(height=10),
                                            ft.Row(
                                                [
                                                    ft.Column([raw_output_box, expected_output_box], spacing=10, expand=1),
                                                    ft.Column([execution_results_box], spacing=10, expand=1),
                                                ],
                                                spacing=15,
                                                vertical_alignment=ft.CrossAxisAlignment.START,
                                            ),
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
            ft.Row([open_csv_button, load_hf_button], spacing=8, wrap=True),
            ft.Row([new_problem_button, cancel_new_problem_button], spacing=8, wrap=True),
            ft.Row([save_button, save_as_button, copy_button], spacing=8, wrap=True),
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
                ft.Row([chat_model_dropdown], spacing=10),
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

    # Initial load. No CSV is bundled with the package — text2zinc is a
    # public HuggingFace dataset, so the very first run in a fresh directory
    # (in either mode) pulls it straight from the Hub instead, no token
    # required. HF mode only ever loads the one pushed dataset (--text2zinc-path,
    # else T2M_EDITOR_DATASET_PATH, else HuggingFace) since there's no
    # "previous session" file — quick-save writes back in place to that same
    # path. Normal mode is local-first: an explicit --text2zinc-path, then a
    # previous editing session, then HuggingFace.
    if HF_MODE:
        hf_mode_source = text2zinc_path or HF_MODE_DATASET_PATH
        if hf_mode_source and os.path.exists(hf_mode_source):
            load_local_path(hf_mode_source, f"pushed dataset ({hf_mode_source})")
        else:
            status_text.value = f"Loading from HuggingFace ({TEXT2ZINC_DATASET})..."
            status_text.color = ft.colors.ORANGE
            page.update()
            finish_loading(
                f"HuggingFace ({TEXT2ZINC_DATASET}, T2M_EDITOR_DATASET_PATH not set or not found)",
                editor.load_from_huggingface(),
            )
    elif text2zinc_path and os.path.exists(text2zinc_path):
        load_local_path(text2zinc_path, text2zinc_path)
    elif os.path.exists(WORKING_DATASET_PATH):
        load_local_path(WORKING_DATASET_PATH, f"previous session ({WORKING_DATASET_PATH})")
    else:
        status_text.value = f"Loading from HuggingFace ({TEXT2ZINC_DATASET})..."
        status_text.color = ft.colors.ORANGE
        page.update()
        finish_loading(f"HuggingFace ({TEXT2ZINC_DATASET})", editor.load_from_huggingface())


def launch(text2zinc_path: Optional[str] = None) -> None:
    """Launch the Text2Zinc dataset editor GUI.

    Locally this opens a native desktop window. In HF mode
    (T2M_HF_MODE=1, e.g. deployed as an HF Space) it instead serves over
    HTTP so it can run headless in a container, listening on $PORT
    (default 7860, matching HF Spaces' Docker SDK default). See the HF_MODE
    comment near the top of this file for the concurrency caveat that comes
    with that deployment."""
    if HF_MODE:
        port = int(os.environ.get("PORT", 7860))
        ft.app(
            target=lambda page: main(page, text2zinc_path=text2zinc_path),
            view=ft.AppView.WEB_BROWSER,
            host="0.0.0.0",
            port=port,
        )
    else:
        ft.app(target=lambda page: main(page, text2zinc_path=text2zinc_path))


if __name__ == "__main__":
    launch()
