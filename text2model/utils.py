import ast
import csv
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

import openai
from langchain_ollama import ChatOllama

# Global OpenAI API configuration
API_CONFIG = {
    'model': 'gpt-4',
    'temperature': 0,
    'max_tokens': 4096,
    'sleep_time': 3
}

# HuggingFace repo backing the Text2Zinc benchmark dataset. This is the
# default dataset source everywhere except the `--editor` GUI, which
# defaults to a local CSV instead (see text2model/editor/app.py).
TEXT2ZINC_DATASET = "skadio/text2zinc"

# Columns of a local Text2Zinc CSV dataset, e.g. one saved by `text2model --editor`.
TEXT2ZINC_CSV_COLUMNS = ['input.json', 'data.dzn', 'model.mzn', 'output.json', 'is_verified']

# Package installation directory — used to locate bundled data files
_PACKAGE_DIR = Path(__file__).parent


def _resolve_path(rel_path: str) -> Path:
    """Resolve a data-file path: try CWD first, then the installed package directory."""
    p = Path(rel_path)
    if p.exists():
        return p
    pkg_p = _PACKAGE_DIR / rel_path
    if pkg_p.exists():
        return pkg_p
    return p  # Return original; callers handle the missing-file case


def extract_code_blocks(text: str) -> str:
    """Extract code blocks from markdown-formatted text"""
    pattern = re.compile(r'```(?:\w+)?\n(.*?)\n```', re.DOTALL)
    matches = pattern.findall(text)
    return matches[0] if matches else text


def extract_global_constraint(text):
    first_line = text.splitlines()[0]
    return re.findall(r'`(.*?)`', first_line)[0]


def call_api(client, model: str, prompt: str) -> Optional[str]:
    if model in ["gpt-4", "gpt-4o", "gpt-5.2"]:
        solution = call_openai_api(client, prompt)
        print(solution)
        return solution
    else:
        solution = call_ollama_api(client, prompt)
        return solution


def call_openai_api(client: openai.OpenAI, prompt: str) -> Optional[str]:
    """Call OpenAI API with the given prompt"""
    try:
        # Map model names - use o3 for gpt-4o, gpt-5.2 uses its own name
        model_name = API_CONFIG['model']
        if model_name == 'gpt-4o':
            model_name = 'o3-2025-04-16'
        # gpt-5.2 uses its own name directly

        params = {
            "model": model_name,
            "messages": [{"role": "user", "content": prompt}]
        }

        # Add temperature and max_tokens only for non-reasoning models
        # Reasoning models: gpt-4o (mapped to o3), gpt-5.2
        if API_CONFIG['model'] not in ['gpt-4o', 'gpt-5.2']:
            params["temperature"] = API_CONFIG['temperature']
            params["max_tokens"] = API_CONFIG['max_tokens']

        completion = client.chat.completions.create(**params)
        result = completion.choices[0].message.content.strip()
        return extract_code_blocks(result)
    except Exception as e:
        print(f"Error calling OpenAI API: {e}")
        return None


def call_ollama_api(client: ChatOllama, prompt: str) -> Optional[str]:
    """Call ChatOllama with the given prompt"""
    try:
        messages = [
            {"role": "user", "content": prompt},
        ]
        result = client.invoke(messages).content.strip()
        return extract_code_blocks(result)
    except Exception as e:
        print(f"Error calling ChatOllama: {e}")
        return None


def check_syntax(mzn_code: str, dzn_data: str, timeout: int = 60) -> Optional[str]:
    """Check MiniZinc syntax and return error message if any"""
    with tempfile.NamedTemporaryFile(suffix='.mzn', mode='w', delete=False) as mzn_f:
        mzn_f.write(mzn_code)
        temp_mzn = mzn_f.name

    temp_dzn = None
    try:
        cmd = [shutil.which("minizinc") or "minizinc", temp_mzn]
        if dzn_data and dzn_data.strip():
            with tempfile.NamedTemporaryFile(suffix='.dzn', mode='w', delete=False) as dzn_f:
                dzn_f.write(dzn_data)
                temp_dzn = dzn_f.name
            cmd.append(temp_dzn)

        result = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        if result.returncode != 0:
            return result.stderr
        return None
    except subprocess.TimeoutExpired:
        return f"MiniZinc execution timed out after {timeout} seconds"
    except Exception as e:
        return f"Error checking syntax: {str(e)}"
    finally:
        if os.path.exists(temp_mzn):
            os.remove(temp_mzn)
        if temp_dzn and os.path.exists(temp_dzn):
            os.remove(temp_dzn)


def parse_dzn_string(dzn_str: str) -> List[Tuple[str, str]]:
    """Parse dzn string into parameter-value pairs"""
    parameters = re.findall(r'(\w+)\s*=\s*[^;]+;', dzn_str)
    content_list = dzn_str.split("\n")
    valid_lines = [line for line in content_list if '=' in line]
    result = list(zip(parameters, valid_lines))
    return result


def create_data_nomenclature(input_data: Dict[str, Any], dzn_data: List[Tuple[str, str]]) -> str:
    """Create data nomenclature section for prompts.

    Returns empty string if no parameters or no dzn_data.
    """
    if not dzn_data:
        return ""

    parameters = input_data.get('parameters', [])

    if not parameters:
        return ""

    data_nomenclature = []

    for idx, param in enumerate(parameters):
        symbol = param['symbol']
        definition = param['definition']
        shape = param['shape']

        example_line = next(
            (line for param_name, line in dzn_data if param_name == symbol),
            f"{symbol} = N/A;"
        )

        shape_display = f"[{', '.join(map(str, shape))}]" if shape else "scalar"

        data_nomenclature.append(
            f"{idx + 1}. {symbol}: {definition}\n"
            f"Example: {example_line}\n"
            f"Shape: {shape_display}"
        )

    return '\n'.join(data_nomenclature)


def prepare_problem_data(problem: Dict[str, Any]) -> Dict[str, Any]:
    """Prepare problem data for use in prompts"""
    input_data = ast.literal_eval(problem['input.json'])

    if problem.get('data.dzn') and problem['data.dzn'].strip():
        dzn_data = parse_dzn_string(problem['data.dzn'])
    else:
        dzn_data = []

    data_nomenclature = create_data_nomenclature(input_data, dzn_data)

    return {
        'description': input_data['description'],
        'data_nomenclature': data_nomenclature,
        'objective_type': input_data.get('metadata', {}).get('objective', 'unknown'),
        'identifier': input_data.get('metadata', {}).get('identifier', ''),
        'input_data': input_data,
        'dzn_data': dzn_data
    }


def get_effective_input_data(problem_data: Dict[str, Any]) -> str:
    """Get the input data, with instructions if no dzn data exists."""
    if not problem_data['data_nomenclature'].strip():
        return """IMPORTANT: All data and parameters are already included in the problem description above.
You must embed all data directly in the MiniZinc model - do not expect external .dzn files or assume data will be provided separately.
Generate MiniZinc code ONLY. Do NOT generate CPOPT, COPT, or any other format even if the problem description mentions it."""

    return problem_data['data_nomenclature']


def create_baseline_prompt(problem: Dict[str, Any]) -> str:
    """Create a baseline prompt for single-stage generation"""
    problem_data = prepare_problem_data(problem)
    effective_input_data = get_effective_input_data(problem_data)

    if problem_data['data_nomenclature'].strip():
        return f"""You are an expert MiniZinc developer.

Generate Minizinc code from a given problem description with additional information about the parameters provided.

The MiniZinc code should assume that the data needed, will be provided in a specific format through a .dzn file, so the generated code should assume the same names defined in the input data nomenclature.

Please do not generate any other token, except the MiniZinc code.

Problem Description:
{problem_data['description']}

Input Data Nomenclature:
{effective_input_data}
"""
    else:
        return f"""You are an expert MiniZinc developer.

Generate MiniZinc code from the given problem description. All data and parameters are included in the problem description, so embed them directly in your MiniZinc model.

IMPORTANT: Generate MiniZinc code ONLY. Do NOT generate CPOPT, COPT, or any other format even if the problem description asks for it.

Please do not generate any other token, except the MiniZinc code.

Problem Description:
{problem_data['description']}
"""


def create_problem_from_text(text: str) -> Dict[str, Any]:
    """Create a dataset-compatible problem dict from a plain text description."""
    input_data = {
        'description': text,
        'parameters': [],
        'metadata': {
            'objective': 'unknown',
            'identifier': 'user_problem',
            'source': 'user',
        }
    }
    return {
        'input.json': repr(input_data),
        'data.dzn': '',
    }


def save_solution(output_dir: str, problem_id: str, solution: str) -> None:
    """Save the generated solution to a file"""
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{problem_id}.mzn")
    with open(output_path, 'w') as f:
        f.write(solution)


def load_file(file_path: str) -> str:
    """Load a file, resolving the path relative to the package directory if not found locally."""
    p = _resolve_path(file_path)
    try:
        return p.read_text()
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return ""


def get_problem_source(problem):
    """Extract the source from problem's input.json metadata"""
    try:
        input_data = ast.literal_eval(problem['input.json'])
        return input_data.get('metadata', {}).get('source', None)
    except Exception:
        return None


def get_problem_identifier(problem, idx):
    """Extract the identifier from problem's input.json metadata."""
    try:
        input_data = ast.literal_eval(problem['input.json'])
        metadata = input_data.get('metadata', {})
        identifier = metadata.get('identifier', '')

        if not identifier or not identifier.strip():
            source = metadata.get('source', 'unknown')
            safe_source = re.sub(r'[^\w\-]', '_', source.lower())
            identifier = f"{safe_source}_problem_{idx}"
        elif identifier in ['easy_lp', 'complex_lp']:
            identifier = f"{identifier}_{idx}"

        return identifier
    except Exception:
        return f"unknown_problem_{idx}"


def get_cardinal_ops_subfolder(problem):
    """Determine the subfolder name for cardinal_operations datasets."""
    try:
        input_data = ast.literal_eval(problem['input.json'])
        metadata = input_data.get('metadata', {})
        source = metadata.get('source', '')
        identifier = metadata.get('identifier', '')

        if not source.startswith('cardinal_operations'):
            return None

        if source == 'cardinal_operations_mamo':
            if identifier == 'easy_lp':
                return 'easylp'
            elif identifier == 'complex_lp':
                return 'complexlp'
            else:
                return 'mamo'
        elif source == 'cardinal_operations_nl4opt':
            return 'nl4opt'
        elif source == 'cardinal_operations_industryor':
            return 'industryor'
        else:
            suffix = source.replace('cardinal_operations_', '')
            return suffix if suffix else None

    except Exception:
        return None


def filter_dataset_by_source(dataset, source_filter):
    """Filter dataset by source field in metadata"""
    def matches_source(problem):
        source = get_problem_source(problem)
        if source is None:
            return False
        return source_filter.lower() in source.lower()

    return dataset.filter(matches_source)


def get_available_sources(dataset):
    """Get all unique sources in the dataset"""
    sources = set()
    for problem in dataset:
        source = get_problem_source(problem)
        if source:
            sources.add(source)
    return sorted(sources)


def load_text2zinc_dataset(dataset_path: Optional[str] = None):
    """Load the Text2Zinc benchmark dataset as a `datasets.Dataset`.

    dataset_path=None (default): pulls TEXT2ZINC_DATASET from the HuggingFace Hub.
    dataset_path=<path>: loads a local Text2Zinc CSV instead (e.g. one saved by
    `text2model --editor`), with the same 5 columns HF exposes: input.json,
    data.dzn, model.mzn, output.json, is_verified.

    Either way the result supports `.filter()`, indexing, `len()`, and
    iteration identically, so callers don't need to branch on the source.
    """
    # `datasets` is imported lazily here (not at module scope) so callers that
    # never touch the benchmark dataset don't pay for/depend on the HF stack.
    from datasets import Dataset, load_dataset

    if dataset_path is None:
        return load_dataset(TEXT2ZINC_DATASET)['train']

    rows = []
    with open(dataset_path, 'r', encoding='utf-8', newline='') as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append({
                'input.json': row.get('input.json') or '',
                'data.dzn': row.get('data.dzn') or '',
                'model.mzn': row.get('model.mzn') or '',
                'output.json': row.get('output.json') or '',
                'is_verified': str(row.get('is_verified', '')).strip().lower() in ('true', '1', 'yes'),
            })
    return Dataset.from_list(rows)
