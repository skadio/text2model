import ast
import csv
from builtins import print as builtin_print
import json
import os
import re
import shutil
import subprocess
import tempfile
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

import openai
from langchain_ollama import ChatOllama

# Global OpenAI API configuration
API_CONFIG = {
    'model': 'gpt-4',
    'temperature': 0,
    'max_tokens': 4096,
    'sleep_time': 3,
    # Reasoning-effort hint for gpt-5.5 / gpt-5.6 only.
    #   None    -> omit the parameter; the API uses its own default ("medium")
    #   "none" / "low" / "medium" / "high" / "xhigh" / "max"
    # ("max" is gpt-5.6 only; valid values depend on the model.)
    'reasoning_effort': None,
}

# OpenAI models this script calls directly. Anything not listed here routes to
# Ollama. gpt-5.5 / gpt-5.6 are added alongside the existing gpt-5.2.
OPENAI_MODELS = ["gpt-4", "gpt-4o", "gpt-5.2", "gpt-5.5", "gpt-5.6"]

# Reasoning models don't accept temperature / max_tokens on Chat Completions.
# (gpt-4o is mapped to o3 below, which is also a reasoning model.)
REASONING_MODELS = {"gpt-4o", "gpt-5.2", "gpt-5.5", "gpt-5.6"}

# Models that accept a `reasoning_effort` hint. Kept separate from
# REASONING_MODELS so existing gpt-4o (o3) and gpt-5.2 calls stay byte-for-byte
# identical to before.
REASONING_EFFORT_MODELS = {"gpt-5.5", "gpt-5.6"}

# HuggingFace repo backing the Text2Zinc benchmark dataset. This is the
# default dataset source everywhere except the `--editor` GUI, which
# defaults to a local CSV instead (see text2model/editor/app.py).
TEXT2ZINC_DATASET = "skadio/text2zinc"

# Columns of a local Text2Zinc CSV dataset, e.g. one saved by `text2model --editor`.
TEXT2ZINC_CSV_COLUMNS = ['input.json', 'data.dzn', 'model.mzn', 'output.json', 'is_verified']

# Package installation directory — used to locate bundled data files
_PACKAGE_DIR = Path(__file__).parent


def print(*args, **kwargs):
    """Print comment-prefixed CLI text so redirected stdout stays MiniZinc-safe."""
    file = kwargs.pop('file', sys.stdout)
    sep = kwargs.pop('sep', ' ')
    end = kwargs.pop('end', '\n')
    flush = kwargs.pop('flush', False)
    text = sep.join(str(arg) for arg in args)
    if text:
        text = '\n'.join(f'% {line}' for line in text.splitlines())
    else:
        text = '% '
    builtin_print(text, file=file, end=end, flush=flush, **kwargs)


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
    if model in OPENAI_MODELS:
        solution = call_openai_api(client, prompt)
        # print(solution)
        return solution

    # Imported lazily (not at module scope) to avoid a circular import, since
    # text2model.huggingface itself imports from this module.
    from text2model import huggingface
    if model in huggingface.HUGGINGFACE_MODELS:
        return huggingface.call_huggingface_api(client, model, prompt)

    solution = call_ollama_api(client, prompt)
    return solution


def call_openai_api(client: openai.OpenAI, prompt: str) -> Optional[str]:
    """Call OpenAI API with the given prompt"""
    try:
        # Map model names - use o3 for gpt-4o; other models use their own name.
        model_name = API_CONFIG['model']
        if model_name == 'gpt-4o':
            model_name = 'o3-2025-04-16'
        # gpt-5.2 / gpt-5.5 / gpt-5.6 use their own names directly.
        # ("gpt-5.6" is an alias that routes to gpt-5.6-sol on OpenAI's side.)

        params = {
            "model": model_name,
            "messages": [{"role": "user", "content": prompt}]
        }

        # Add temperature and max_tokens only for non-reasoning models.
        if API_CONFIG['model'] not in REASONING_MODELS:
            params["temperature"] = API_CONFIG['temperature']
            params["max_tokens"] = API_CONFIG['max_tokens']

        # Optionally pass a reasoning-effort hint for gpt-5.5 / gpt-5.6.
        # Left as None (the default) the field is omitted, so the API applies
        # its own default and nothing changes for the older models.
        reasoning_effort = API_CONFIG.get('reasoning_effort')
        if reasoning_effort and API_CONFIG['model'] in REASONING_EFFORT_MODELS:
            params["reasoning_effort"] = reasoning_effort

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


def verify_minizinc_solution(model_code, dzn_string, expected_output, problem_type,
                              timeout: int = 60, solver: str = "highs", reference_model=None):
    """Run a MiniZinc model with optional dzn string and compare output with expected solution.

    Intentionally a standalone copy of the correctness check in evals/evaluate.py's
    `run_minizinc_evaluation` (kept independent on purpose so evals/evaluate.py, and
    its published/reproducible results, are never affected by editor-side changes).
    Used by the editor's "Execute" panel to verify a row's model.mzn/data.dzn against
    its recorded output.json, with the same semantics used for grading in the paper's
    evals: objective-value matching for optimization problems, and solution-satisfies-
    constraints verification (via pinning) for satisfaction problems.
    """
    model_path = None
    data_path = None
    output_path = None
    verif_path = None

    try:
        with tempfile.NamedTemporaryFile(suffix='.mzn', mode='w', delete=False) as model_file:
            model_file.write(model_code)
            model_path = model_file.name

        has_dzn = bool(dzn_string and dzn_string.strip())
        if has_dzn:
            with tempfile.NamedTemporaryFile(suffix='.dzn', mode='w', delete=False) as data_file:
                data_file.write(dzn_string)
                data_path = data_file.name

        if problem_type == "satisfaction":
            # =================================================================
            # SATISFACTION VERIFICATION (two-pass approach)
            #
            # Pass 1: Solve the model → get variable assignments
            # Pass 2: Pin those assignments into the reference model (defaults
            #         to the same model if none given) and re-solve. If SAT,
            #         the solution respects the real constraints. If
            #         UNSATISFIABLE, the solution was wrong.
            # =================================================================

            # --- Pass 1: Solve model, output assignments as .dzn ---
            with tempfile.NamedTemporaryFile(suffix='.dzn', mode='w', delete=False) as output_file:
                output_path = output_file.name

            cmd = [
                "minizinc",
                "--solver", solver,
                "--output-mode", "dzn",   # critical: outputs raw variable assignments
                model_path
            ]
            if has_dzn:
                cmd.append(data_path)
            cmd.extend(["-o", output_path])

            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout
            )

            # Solver crashed or model has syntax errors → execution failure
            if result.returncode != 0:
                return False, False, result.stderr

            with open(output_path, 'r') as f:
                output_lines = f.readlines()

            # Model itself is unsatisfiable → execution OK, solution wrong
            if "UNSATISFIABLE" in " ".join(output_lines).upper():
                execution_success = True
                solution_success = False
                return execution_success, solution_success, result.stdout

            # Strip the "----------" separator line if present
            if output_lines and '---' in output_lines[-1]:
                output_lines = output_lines[:-1]

            # Parse dzn output lines into constraint expressions
            # e.g. "x = [1, 1, 3];" becomes a pinning constraint
            verification_constraints = []
            for line in output_lines:
                line = line.strip()
                if line and '=' in line:
                    verification_constraints.append(line.replace(" = ", " = "))

            # --- Pass 2: Pin assignments into reference model, re-solve ---
            base_model = reference_model if reference_model else model_code
            verification_model = base_model + "\nconstraint\n  " + " /\\\n  ".join(
                [c.rstrip(';') for c in verification_constraints]
            ) + ";\n"

            with tempfile.NamedTemporaryFile(suffix='.mzn', mode='w', delete=False) as verif_file:
                verif_file.write(verification_model)
                verif_path = verif_file.name

            verif_cmd = [
                "minizinc",
                "--solver", solver,
                verif_path
            ]
            if has_dzn:
                verif_cmd.append(data_path)

            verif_result = subprocess.run(
                verif_cmd,
                capture_output=True,
                text=True,
                timeout=timeout
            )

            execution_success = True  # Pass 1 succeeded, so execution is OK
            # Pass 2 verdict: SAT = solution is valid, UNSAT = solution is wrong
            solution_success = (
                    verif_result.returncode == 0 and
                    'UNSATISFIABLE' not in verif_result.stdout.upper() and
                    'UNSATISFIABLE' not in verif_result.stderr.upper()
            )

            return execution_success, solution_success, verif_result.stdout

        else:
            # Handle optimization problems
            with tempfile.NamedTemporaryFile(suffix='.json', mode='w', delete=False) as output_file:
                output_path = output_file.name

            cmd = [
                "minizinc",
                "--solver", solver,
                "--output-objective",
                "--output-mode", "json",
                model_path
            ]
            if has_dzn:
                cmd.append(data_path)
            cmd.extend(["-o", output_path])

            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                timeout=timeout
            )

            execution_success = result.returncode == 0

            if execution_success:
                with open(output_path, 'r') as f:
                    output_text = f.read()
                json_match = re.search(r'{.*}', output_text, re.DOTALL)
                if json_match:
                    json_str = json_match.group(0)
                    output_json = json.loads(json_str)
                else:
                    return execution_success, False, "No objective value found in output"

                if "_objective" in output_json:
                    actual_output = float(output_json["_objective"])
                    expected = float(json.loads(expected_output)["_objective"])
                    # Compare output values
                    solution_success = abs(actual_output - expected) < 1e-6
                    return execution_success, solution_success, str(actual_output)
                else:
                    return execution_success, False, "No objective value found in output"
            else:
                return execution_success, False, result.stderr

    except subprocess.TimeoutExpired:
        return False, False, f"Execution timed out after {timeout} seconds"

    except Exception as e:
        return False, False, str(e)

    finally:
        # Clean up all temporary files
        for path in [model_path, data_path, output_path, verif_path]:
            try:
                if path and os.path.exists(path):
                    os.unlink(path)
            except Exception:
                pass


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


def create_kg_generation_prompt(problem_data: Dict[str, Any], effective_input_data: str) -> str:
    """Build the prompt used to generate a knowledge-graph (TTL) for a problem."""
    kg_prompt_template = load_file('prompts/kg_generation_prompt.txt')
    return kg_prompt_template.format(
        problem_description=problem_data['description'],
        input_data=effective_input_data,
    )


def get_knowledge_graph(
    client, model: str, problem_identifier: str,
    problem_data: Dict[str, Any], effective_input_data: str,
) -> Optional[str]:
    """Return the TTL knowledge graph text to use for a problem.

    Uses the bundled, manually-verified .ttl under knowledge_graphs/ when one
    exists for `problem_identifier` (the 110 curated problems); otherwise
    generates one on the fly via an extra LLM call, so the `knowledge_graph`
    strategy also works in text mode (--problem) and for Text2Zinc problems
    outside the verified set.
    """
    kg_path = _resolve_path(f"knowledge_graphs/{problem_identifier}.ttl")
    if kg_path.exists():
        return load_file(str(kg_path))

    print(f"No pre-built knowledge graph for '{problem_identifier}'; generating one on the fly...")
    kg_prompt = create_kg_generation_prompt(problem_data, effective_input_data)
    return call_api(client, model, kg_prompt)


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


def resolve_problem_ids(dataset, problem_ids: List[str]) -> List[Tuple[int, Dict[str, Any]]]:
    """Resolve --problem-ids tokens to (idx, problem) pairs.

    Each token may be either a dataset index (e.g. "0") or a problem
    identifier (e.g. "nlp4lp_58" — the same identifier `get_problem_identifier`
    assigns and that output/.ttl filenames use). A token is tried as an index
    first; if it isn't one, it's looked up by identifier. Unmatched or
    out-of-range tokens are skipped with a printed warning. Duplicate
    identifiers resolve to their first occurrence.

    `dataset` should already reflect any --full-dataset / --source filtering,
    so indices and identifiers both resolve against the same view a caller
    would otherwise iterate with `enumerate(dataset)`.
    """
    identifier_to_idx: Optional[Dict[str, int]] = None
    resolved = []

    for token in problem_ids:
        idx = None
        try:
            candidate = int(token)
        except ValueError:
            candidate = None

        if candidate is not None:
            if -len(dataset) <= candidate < len(dataset):
                idx = candidate
            else:
                print(f"Problem index '{token}' is out of range (dataset has {len(dataset)} problems); skipping.")
        else:
            if identifier_to_idx is None:
                identifier_to_idx = {}
                for i, problem in enumerate(dataset):
                    identifier_to_idx.setdefault(get_problem_identifier(problem, i), i)

            if token in identifier_to_idx:
                idx = identifier_to_idx[token]
            else:
                print(f"Unknown problem id or identifier '{token}'; skipping. "
                      f"Use --list-problem-ids to see available indices/identifiers.")

        if idx is not None:
            resolved.append((idx, dataset[idx]))

    return resolved


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


HF_TOKEN_HELP = (
    f"{TEXT2ZINC_DATASET} is a gated dataset: the `datasets` library falls back "
    "silently to whatever is in the local cache when it can't authenticate, which "
    "looks identical to a successful fresh load. To fetch/refresh it from the Hub, "
    f"request access at https://huggingface.co/datasets/{TEXT2ZINC_DATASET} and then "
    "either run `huggingface-cli login` or set the HF_TOKEN environment variable to a "
    "token with approved access.\n"
    "On a HuggingFace Space, add HF_TOKEN as a Repository secret "
    "(Settings > Variables and secrets > New secret) instead of putting it in code "
    "or the repo — Spaces inject secrets into the running container as environment "
    "variables at runtime, which `huggingface_hub` picks up automatically."
)


def check_hf_token_for_text2zinc(force_download: bool = False) -> None:
    """Warn (or, for a forced refresh, raise) if no Hugging Face token is
    configured before touching the gated TEXT2ZINC_DATASET on the Hub.

    `datasets.load_dataset` swallows auth/permission failures against gated
    repos and silently reuses the local cache instead of erroring, so without
    this check a missing/invalid token is indistinguishable from a successful
    fresh load. force_download=True raises instead of warning, since the whole
    point of forcing a refresh is defeated by silently serving stale data.
    """
    from huggingface_hub import get_token

    if get_token():
        return
    if force_download:
        raise RuntimeError(HF_TOKEN_HELP)
    print(f"Warning: no Hugging Face token found. {HF_TOKEN_HELP}")


def load_text2zinc_dataset(text2zinc_path: Optional[str] = None, force_download: bool = False):
    """Load the Text2Zinc benchmark dataset as a `datasets.Dataset`.

    text2zinc_path=None (default): pulls TEXT2ZINC_DATASET from the HuggingFace Hub.
    text2zinc_path=<path>: loads a local Text2Zinc CSV instead (e.g. one saved by
    `text2model --editor`), with the same 5 columns HF exposes: input.json,
    data.dzn, model.mzn, output.json, is_verified.

    force_download=True (only meaningful when text2zinc_path is None): bypasses
    the local HuggingFace datasets cache and re-downloads TEXT2ZINC_DATASET from
    the Hub, in case it's been updated since it was last cached. Raises if no HF
    token is configured, since serving stale cache would silently defeat the point.

    Either way the result supports `.filter()`, indexing, `len()`, and
    iteration identically, so callers don't need to branch on the source.
    """
    # `datasets` is imported lazily here (not at module scope) so callers that
    # never touch the benchmark dataset don't pay for/depend on the HF stack.
    from datasets import DownloadMode, Dataset, load_dataset

    if text2zinc_path is None:
        check_hf_token_for_text2zinc(force_download)
        download_mode = DownloadMode.FORCE_REDOWNLOAD if force_download else None
        return load_dataset(TEXT2ZINC_DATASET, download_mode=download_mode)['train']

    rows = []
    with open(text2zinc_path, 'r', encoding='utf-8', newline='') as f:
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