import ast
import csv
import json
import os
import subprocess
import tempfile
from typing import Any, Dict, List

from text2model.utils import TEXT2ZINC_CSV_COLUMNS, TEXT2ZINC_DATASET


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


def blank_problem(identifier: str) -> Dict[str, Any]:
    """A new problem, shaped exactly like every other row in the dataset, with
    every field left empty for the user to fill in via the normal edit UI."""
    return {
        'input.json': {
            'description': '',
            'parameters': [],
            'output': [],
            'metadata': {
                'name': '',
                'domain': '',
                'objective': '',
                'source': '',
                'constraints': [],
                'identifier': identifier,
            },
        },
        'data.dzn': '',
        'model.mzn': '',
        'output.json': {},
        'is_verified': False,
    }


def validate_item(item: Dict[str, Any]) -> List[str]:
    """Check the minimal set of mandatory fields a problem needs to be worth
    exporting. Returns human-readable descriptions of what's missing — an
    empty list means the item is valid."""
    missing = []

    input_json = item.get('input.json', {})
    if not isinstance(input_json, dict):
        input_json = {}

    if not str(input_json.get('description') or '').strip():
        missing.append("Problem description (Input tab)")

    metadata = input_json.get('metadata', {})
    if not isinstance(metadata, dict):
        metadata = {}

    if not str(metadata.get('source') or '').strip():
        missing.append("Source (Input tab → metadata.source)")

    has_model = bool(str(item.get('model.mzn') or '').strip())
    has_objective = bool(str(metadata.get('objective') or '').strip())
    if not has_model and not has_objective:
        missing.append("MiniZinc model code (Model tab) or an objective (Input tab → metadata.objective)")

    return missing


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
