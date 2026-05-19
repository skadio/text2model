import argparse
import ast
import json
import os
import re
import subprocess
import tempfile
import traceback
from datetime import datetime
from collections import defaultdict

import pandas as pd
from datasets import load_dataset
from tqdm import tqdm


# =============================================================================
# CONFIGURATION
# =============================================================================

STRATEGY_FOLDER_TO_NAME = {
    "baseline": "baseline",
    "cot": "cot",
    "knowledge_graph": "knowledge_graph",
    "cot_with_code_validation": "cot+code_val",
    "cot_with_grammar_validation": "cot+gram_val",
    "cot_with_code_and_grammar_validation": "cot+code+gram",
    "agents": "agents",
    "gala": "gala",
    "agents_with_code_validation": "agents+code_val",
}

STRATEGY_LLM_CALLS = {
    "baseline": 1,
    "cot": 1,
    "knowledge_graph": 2,
    "cot+code_val": 2,
    "cot+gram_val": 2,
    "cot+code+gram": 3,
    "agents": 4,
    "gala": 4,
    "agents+code_val": 5,
}

STRATEGIES_ORDER = [
    "baseline", "cot", "knowledge_graph", "cot+code_val", "cot+gram_val",
    "cot+code+gram", "agents", "gala", "agents+code_val",
]

VERIFIED_DATASETS_ORDER = ["nlp4lp", "complexor", "lpwp", "csplib", "hakank"]
ORLM_DATASETS_ORDER = ["industryor", "easylp", "complexlp", "nl4opt"]


def get_strategy_display_name(folder_name):
    return STRATEGY_FOLDER_TO_NAME.get(folder_name, folder_name)


def get_llm_calls(strategy_name):
    return STRATEGY_LLM_CALLS.get(strategy_name, "?")


# =============================================================================
# MINIZINC HELPERS
# =============================================================================

def verify_minizinc_installation():
    """Check if MiniZinc is installed and accessible."""
    try:
        result = subprocess.run(
            ["minizinc", "--version"],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            print(f"✓ MiniZinc installation verified: {result.stdout.strip()}")
            return True
        else:
            print("✗ MiniZinc executable found but returned an error")
            return False
    except FileNotFoundError:
        print("✗ MiniZinc not found. Please install MiniZinc and make sure it's in your PATH")
        return False


def get_model_code(file_path):
    """Read model code from file."""
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            return f.read()
    return None


def run_minizinc_evaluation(model_code, dzn_string, expected_output, problem_type, timeout=60, solver="highs", reference_model=None):
    """Run MiniZinc model with optional dzn string and compare output with expected solution."""
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
            # Pass 1: Solve the LLM-generated model → get variable assignments
            # Pass 2: Pin those assignments into the GROUND TRUTH model and
            #         re-solve. If the ground truth model + pinned values is
            #         satisfiable, the LLM's solution respects the real
            #         constraints. If UNSATISFIABLE, the LLM's model was wrong.
            # =================================================================

            # --- Pass 1: Solve LLM model, output assignments as .dzn ---
            with tempfile.NamedTemporaryFile(suffix='.dzn', mode='w', delete=False) as output_file:
                output_path = output_file.name

            cmd = [
                "minizinc",
                "--solver", solver,
                "--output-mode", "dzn",   # critical: outputs raw variable assignments
                model_path                # LLM-generated model
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

            # LLM model itself is unsatisfiable → execution OK, solution wrong
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

            # --- Pass 2: Pin assignments into GROUND TRUTH model, re-solve ---
            # Use the reference (ground truth) model instead of the LLM model.
            # This way we check: does the LLM's solution satisfy the REAL
            # constraints, not just the LLM's own (potentially wrong) constraints?
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
                verif_path          # ground truth model + pinned assignments
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


def evaluate_directory(strategy_dir, problems, timeout, solver, desc=""):
    """
    Evaluate all .mzn files in a directory against the problems dict.
    Returns metrics: {attempted, execution, solution, results}
    """
    if not os.path.exists(strategy_dir):
        return None

    results = []
    metrics = {"attempted": 0, "execution": 0, "solution": 0}

    # Get all .mzn files
    def natural_sort_key(filename):
        return [int(part) if part.isdigit() else part.lower()
                for part in re.split(r'(\d+)', filename)]

    mzn_files = sorted([f for f in os.listdir(strategy_dir) if f.endswith('.mzn')],
                       key=natural_sort_key)

    if not mzn_files:
        return None

    for mzn_file in tqdm(mzn_files, desc=desc, leave=False):
        try:
            # Extract problem key from filename
            problem_key = mzn_file.replace('.mzn', '')

            if problem_key not in problems:
                continue

            problem_data = problems[problem_key]
            model_code = get_model_code(os.path.join(strategy_dir, mzn_file))

            if not model_code:
                continue

            execution_success, solution_success, output = run_minizinc_evaluation(
                model_code,
                problem_data['dzn_string'],
                problem_data['expected_output'],
                problem_data['problem_type'],
                timeout=timeout,
                solver=solver,
                reference_model=problem_data.get('reference_model')
            )

            metrics["attempted"] += 1
            metrics["execution"] += execution_success
            metrics["solution"] += solution_success

            results.append({
                "problem_key": problem_key,
                "problem_type": problem_data['problem_type'],
                "source": problem_data.get('source', 'unknown'),
                "execution_success": execution_success,
                "solution_success": solution_success,
                "output": output[:1000] if len(output) > 1000 else output
            })

        except Exception as e:
            print(f"\nError evaluating {mzn_file}: {e}")
            traceback.print_exc()
            continue

    if metrics["attempted"] == 0:
        return None

    metrics["results"] = results
    return metrics


def load_verified_problems():
    """
    Load verified problems from HuggingFace dataset.
    Returns dict keyed by identifier (which matches filename).
    """
    print("Loading VERIFIED problems from HuggingFace dataset...")
    dataset = load_dataset("skadio/text2zinc")['train']
    verified = dataset.filter(lambda x: x["is_verified"])

    problems = {}
    for idx, example in enumerate(verified):
        input_data = ast.literal_eval(example['input.json'])
        metadata = input_data.get('metadata', {})
        identifier = metadata.get('identifier', '')
        source = metadata.get('source', 'unknown')

        # The identifier directly matches the filename (e.g., 'CSPLib_12' -> 'CSPLib_12.mzn')
        if identifier:
            dzn_string = example.get('data.dzn', '') or ''
            problems[identifier] = {
                'dzn_string': dzn_string,
                'has_dzn': bool(dzn_string and dzn_string.strip()),
                'expected_output': example['output.json'],
                'problem_type': metadata.get('objective', 'optimization'),
                'source': source,
                'identifier': identifier,
                'hf_index': idx,
                'reference_model': example.get('model.mzn', ''),
            }

    print(f"  Loaded {len(problems)} verified problems")

    # Group by source for reporting
    by_source = defaultdict(int)
    for p in problems.values():
        by_source[p['source']] += 1
    for src, cnt in sorted(by_source.items()):
        print(f"    {src}: {cnt}")

    return problems


def load_orlm_problems():
    """
    Load ORLM (unverified) problems from HuggingFace dataset.

    ORLM sources:
    - cardinal_operations_mamo (identifier: easy_lp or complex_lp)
    - cardinal_operations_industryor
    - cardinal_operations_nl4opt

    Returns dict with keys matching expected filenames.
    """
    print("\nLoading ORLM (unverified) problems from HuggingFace dataset...")
    dataset = load_dataset("skadio/text2zinc")['train']

    # Filter to only ORLM sources
    orlm_sources = ['cardinal_operations_mamo', 'cardinal_operations_industryor', 'cardinal_operations_nl4opt']

    problems = {
        'easylp': {},
        'complexlp': {},
        'industryor': {},
        'nl4opt': {}
    }

    # Track indices within each category
    easylp_idx = 0
    complexlp_idx = 0
    industryor_idx = 0
    nl4opt_idx = 0

    for example in dataset:
        if example['is_verified']:
            continue

        input_data = ast.literal_eval(example['input.json'])
        metadata = input_data.get('metadata', {})
        source = metadata.get('source', '')
        identifier = metadata.get('identifier', '')

        if source not in orlm_sources:
            continue

        dzn_string = example.get('data.dzn', '') or ''
        problem_data = {
            'dzn_string': dzn_string,
            'has_dzn': bool(dzn_string and dzn_string.strip()),
            'expected_output': example['output.json'],
            'problem_type': metadata.get('objective', 'optimization'),
            'source': source,
            'identifier': identifier
        }

        if source == 'cardinal_operations_mamo':
            if identifier == 'easy_lp':
                key = f"easy_lp_{easylp_idx}"
                problems['easylp'][key] = problem_data
                problems['easylp'][f"cardinal_operations_mamo_{key}"] = problem_data
                easylp_idx += 1
            elif identifier == 'complex_lp':
                key = f"complex_lp_{complexlp_idx}"
                problems['complexlp'][key] = problem_data
                problems['complexlp'][f"cardinal_operations_mamo_{key}"] = problem_data
                complexlp_idx += 1

        elif source == 'cardinal_operations_industryor':
            key = f"cardinal_operations_industryor_problem_{industryor_idx}"
            problems['industryor'][key] = problem_data
            industryor_idx += 1

        elif source == 'cardinal_operations_nl4opt':
            key = f"cardinal_operations_nl4opt_problem_{nl4opt_idx}"
            problems['nl4opt'][key] = problem_data
            nl4opt_idx += 1

    print(f"  Loaded ORLM problems:")
    print(f"    easylp: {easylp_idx} problems")
    print(f"    complexlp: {complexlp_idx} problems")
    print(f"    industryor: {industryor_idx} problems")
    print(f"    nl4opt: {nl4opt_idx} problems")

    return problems


# =============================================================================
# EVALUATION RUNNERS
# =============================================================================

def run_verified_evaluation(model_dir, problems, timeout, solver, strategy_filter=None):
    """
    Run evaluation on verified problems.

    Handles two layouts:
      - Standard:  model_dir/<strategy>/*.mzn
      - gpt-5.2:   model_dir/verified_problems/<strategy>/*.mzn

    Returns: {strategy_display_name: eval_result}
    """
    verified_subdir = os.path.join(model_dir, "verified_problems")
    if os.path.isdir(verified_subdir):
        strategies_root = verified_subdir
    else:
        strategies_root = model_dir

    strategies = [d for d in os.listdir(strategies_root)
                  if os.path.isdir(os.path.join(strategies_root, d))
                  and d != "evaluation_results" and d != "orlm"]

    if strategy_filter:
        strategies = [d for d in strategies if d == strategy_filter]

    if not strategies:
        print("  No strategy directories found")
        return {}

    all_results = {}

    for strategy_folder in sorted(strategies):
        strategy_name = get_strategy_display_name(strategy_folder)
        strategy_path = os.path.join(strategies_root, strategy_folder)

        print(f"\nEvaluating {strategy_name}...")

        eval_result = evaluate_directory(
            strategy_path, problems, timeout, solver,
            desc=f"{strategy_name}"
        )

        if eval_result:
            all_results[strategy_name] = eval_result

    return all_results


def run_orlm_evaluation(model_dir, orlm_problems, timeout, solver):
    """
    Run evaluation on ORLM problems.
    Layout: model_dir/orlm/<dataset>/<strategy>/*.mzn

    Returns: {strategy_display_name: {dataset: eval_result}}
    """
    orlm_dir = os.path.join(model_dir, "orlm")

    if not os.path.exists(orlm_dir):
        print(f"ORLM directory not found: {orlm_dir}")
        return {}

    results = defaultdict(dict)

    datasets = [d for d in os.listdir(orlm_dir)
                if os.path.isdir(os.path.join(orlm_dir, d))]

    for dataset_folder in sorted(datasets):
        dataset_path = os.path.join(orlm_dir, dataset_folder)
        problems_for_dataset = orlm_problems.get(dataset_folder, {})

        if not problems_for_dataset:
            print(f"\nSkipping {dataset_folder} - no problems loaded")
            continue

        print(f"\nDataset: {dataset_folder} ({len(problems_for_dataset)//2} problems)")

        strategies = [d for d in os.listdir(dataset_path)
                      if os.path.isdir(os.path.join(dataset_path, d))]

        for strategy_folder in sorted(strategies):
            strategy_name = get_strategy_display_name(strategy_folder)
            strategy_path = os.path.join(dataset_path, strategy_folder)

            print(f"  Evaluating {strategy_name}...")

            eval_result = evaluate_directory(
                strategy_path, problems_for_dataset, timeout, solver,
                desc=f"{dataset_folder}/{strategy_name}"
            )

            if eval_result:
                results[strategy_name][dataset_folder] = eval_result

    return dict(results)


# =============================================================================
# TABLE PRINTING
# =============================================================================

def print_overall_table(all_model_results, title):
    """
    TABLE 1: One row per model/strategy, all verified problems combined.
    all_model_results: {model_name: {strategy: eval_result}}
    """
    print(f"\n{'='*90}")
    print(f"{title}")
    print(f"{'='*90}")
    print(f"{'Model':<20} {'Strategy':<25} {'LLM':>4} {'Attempted':>10} {'Exec%':>10} {'Sol%':>10}")
    print("-" * 90)

    for model_name, strategy_results in sorted(all_model_results.items()):
        def get_strategy_list():
            ordered = [s for s in STRATEGIES_ORDER if s in strategy_results]
            extra = [s for s in strategy_results if s not in STRATEGIES_ORDER]
            return ordered + extra

        for strategy in get_strategy_list():
            er = strategy_results[strategy]
            n = er["attempted"]
            exec_acc = round((er["execution"] / n) * 100, 2)
            sol_acc = round((er["solution"] / n) * 100, 2)
            llm_calls = get_llm_calls(strategy)
            print(f"{model_name:<20} {strategy:<25} {llm_calls:>4} {n:>10} {exec_acc:>10} {sol_acc:>10}")


def print_per_source_table(all_model_results, datasets_order, title):
    """
    TABLE 2: One row per model/strategy, columns are per-dataset (n, exec%, sol%).
    all_model_results: {model_name: {strategy: eval_result}}
    """
    print(f"\n{'='*140}")
    print(f"{title}")
    print(f"{'='*140}")

    header = f"{'Model':<15} {'Strategy':<22} {'LLM':>4}"
    for ds in datasets_order:
        header += f" | {ds:>20}"
    header += f" | {'Avg Exec%':>10} {'Avg Sol%':>10}"
    print(header)
    print("-" * 140)

    for model_name, strategy_results in sorted(all_model_results.items()):
        def get_strategy_list():
            ordered = [s for s in STRATEGIES_ORDER if s in strategy_results]
            extra = [s for s in strategy_results if s not in STRATEGIES_ORDER]
            return ordered + extra

        for strategy in get_strategy_list():
            er = strategy_results[strategy]
            source_metrics = defaultdict(lambda: {"attempted": 0, "execution": 0, "solution": 0})
            for r in er["results"]:
                src = r["source"].lower()
                source_metrics[src]["attempted"] += 1
                source_metrics[src]["execution"] += r["execution_success"]
                source_metrics[src]["solution"] += r["solution_success"]

            llm_calls = get_llm_calls(strategy)
            row = f"{model_name:<15} {strategy:<22} {llm_calls:>4}"

            total_attempted = 0
            total_exec = 0
            total_sol = 0

            for ds in datasets_order:
                m = source_metrics.get(ds)
                if m and m["attempted"] > 0:
                    n = m["attempted"]
                    ea = round((m["execution"] / n) * 100, 1)
                    sa = round((m["solution"] / n) * 100, 1)
                    row += f" | {f'({n}, {ea}, {sa})':>20}"
                    total_attempted += n
                    total_exec += m["execution"]
                    total_sol += m["solution"]
                else:
                    row += f" | {'(--, --, --)':>20}"

            if total_attempted > 0:
                avg_e = round((total_exec / total_attempted) * 100, 2)
                avg_s = round((total_sol / total_attempted) * 100, 2)
            else:
                avg_e = "--"
                avg_s = "--"

            row += f" | {avg_e:>10} {avg_s:>10}"
            print(row)


def print_orlm_table(all_orlm_results, title):
    """
    TABLE 3: ORLM results.
    all_orlm_results: {model_name: {strategy: {dataset: eval_result}}}
    """
    print(f"\n{'='*140}")
    print(f"{title}")
    print(f"{'='*140}")

    header = f"{'Model':<15} {'Strategy':<22} {'LLM':>4}"
    for ds in ORLM_DATASETS_ORDER:
        header += f" | {ds:>20}"
    header += f" | {'Avg Exec%':>10} {'Avg Sol%':>10}"
    print(header)
    print("-" * 140)

    for model_name, strategy_results in sorted(all_orlm_results.items()):
        def get_strategy_list():
            ordered = [s for s in STRATEGIES_ORDER if s in strategy_results]
            extra = [s for s in strategy_results if s not in STRATEGIES_ORDER]
            return ordered + extra

        for strategy in get_strategy_list():
            dataset_results = strategy_results[strategy]
            llm_calls = get_llm_calls(strategy)
            row = f"{model_name:<15} {strategy:<22} {llm_calls:>4}"

            total_attempted = 0
            total_exec = 0
            total_sol = 0

            for ds in ORLM_DATASETS_ORDER:
                er = dataset_results.get(ds)
                if er and er["attempted"] > 0:
                    n = er["attempted"]
                    ea = round((er["execution"] / n) * 100, 1)
                    sa = round((er["solution"] / n) * 100, 1)
                    row += f" | {f'({n}, {ea}, {sa})':>20}"
                    total_attempted += n
                    total_exec += er["execution"]
                    total_sol += er["solution"]
                else:
                    row += f" | {'(--, --, --)':>20}"

            if total_attempted > 0:
                avg_e = round((total_exec / total_attempted) * 100, 2)
                avg_s = round((total_sol / total_attempted) * 100, 2)
            else:
                avg_e = "--"
                avg_s = "--"

            row += f" | {avg_e:>10} {avg_s:>10}"
            print(row)


# =============================================================================
# SAVE RESULTS
# =============================================================================

def save_results_json(all_verified, all_orlm, output_file):
    """Save all results to JSON."""
    def clean_verified(model_results):
        out = {}
        for strategy, er in model_results.items():
            source_metrics = defaultdict(lambda: {"attempted": 0, "execution": 0, "solution": 0})
            for r in er["results"]:
                src = r["source"].lower()
                source_metrics[src]["attempted"] += 1
                source_metrics[src]["execution"] += r["execution_success"]
                source_metrics[src]["solution"] += r["solution_success"]

            out[strategy] = {
                "overall": {
                    "attempted": er["attempted"],
                    "execution": er["execution"],
                    "solution": er["solution"],
                    "exec_acc": round((er["execution"] / er["attempted"]) * 100, 2) if er["attempted"] else 0,
                    "sol_acc": round((er["solution"] / er["attempted"]) * 100, 2) if er["attempted"] else 0,
                },
                "by_source": {
                    src: {
                        "attempted": m["attempted"],
                        "exec_acc": round((m["execution"] / m["attempted"]) * 100, 2),
                        "sol_acc": round((m["solution"] / m["attempted"]) * 100, 2),
                    }
                    for src, m in source_metrics.items() if m["attempted"] > 0
                }
            }
        return out

    def clean_orlm(orlm_res):
        out = {}
        for strategy, ds_map in orlm_res.items():
            out[strategy] = {}
            for ds, er in ds_map.items():
                if er and er["attempted"] > 0:
                    out[strategy][ds] = {
                        "attempted": er["attempted"],
                        "exec_acc": round((er["execution"] / er["attempted"]) * 100, 2),
                        "sol_acc": round((er["solution"] / er["attempted"]) * 100, 2),
                    }
        return out

    payload = {
        "verified_results": {
            model: clean_verified(strats) for model, strats in all_verified.items()
        },
        "orlm_results": {
            model: clean_orlm(strats) for model, strats in all_orlm.items()
        } if all_orlm else None,
        "evaluation_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }

    with open(output_file, 'w') as f:
        json.dump(payload, f, indent=2)

    print(f"\nResults saved to: {output_file}")


def main():
    parser = argparse.ArgumentParser(description='Evaluate Text2Zinc MiniZinc code generation')
    parser.add_argument('--output-dir', required=True,
                        help='Base output directory containing model folders')
    parser.add_argument('--model',
                        help='Evaluate only this model (folder name)')
    parser.add_argument('--strategy',
                        help='Evaluate only this strategy (folder name)')
    parser.add_argument('--timeout', type=int, default=60,
                        help='Timeout in seconds for each problem (default: 60)')
    parser.add_argument('--solver', default='highs',
                        help='MiniZinc solver to use')
    parser.add_argument('--eval-orlm', action='store_true', default=True,
                        help='Also evaluate ORLM problems (default: True)')
    parser.add_argument('--no-eval-orlm', action='store_false', dest='eval_orlm',
                        help='Skip ORLM evaluation')
    parser.add_argument('--output-json', default='evaluation_results.json',
                        help='Output JSON file')

    args = parser.parse_args()

    if not os.path.exists(args.output_dir):
        print(f"Output directory not found: {args.output_dir}")
        return 1

    if not verify_minizinc_installation():
        return 1

    # --- Discover models ---
    skip_dirs = {"evaluation_results"}
    if args.model:
        models_to_evaluate = [args.model]
    else:
        models_to_evaluate = sorted([
            d for d in os.listdir(args.output_dir)
            if os.path.isdir(os.path.join(args.output_dir, d)) and d not in skip_dirs
        ])

    verified_problems = load_verified_problems()
    if not verified_problems:
        print("Failed to load verified problems")
        return 1

    orlm_problems = None
    if args.eval_orlm:
        orlm_problems = load_orlm_problems()

    # --- Print config ---
    print(f"\n{'='*60}")
    print("EVALUATION CONFIGURATION")
    print(f"{'='*60}")
    print(f"Output directory: {args.output_dir}")
    print(f"Models:           {', '.join(models_to_evaluate)}")
    print(f"Strategy filter:  {args.strategy or 'All'}")
    print(f"Timeout:          {args.timeout}s")
    print(f"Solver:           {args.solver}")
    print(f"Evaluate ORLM:    {args.eval_orlm}")
    print(f"{'='*60}")

    # --- Evaluate all models ---
    all_verified = {}   # {model_name: {strategy: eval_result}}
    all_orlm = {}       # {model_name: {strategy: {dataset: eval_result}}}

    for model_name in models_to_evaluate:
        model_dir = os.path.join(args.output_dir, model_name)
        if not os.path.exists(model_dir):
            print(f"Model directory not found: {model_dir}")
            continue

        # Verified problems
        print(f"\n{'='*60}")
        print(f"EVALUATING: {model_name} — Verified Problems")
        print(f"{'='*60}")

        verified_results = run_verified_evaluation(
            model_dir, verified_problems, args.timeout, args.solver,
            strategy_filter=args.strategy
        )

        if verified_results:
            all_verified[model_name] = verified_results

        # ORLM: only if flag set and model has orlm/ subfolder
        if args.eval_orlm and orlm_problems and os.path.isdir(os.path.join(model_dir, "orlm")):
            print(f"\n{'='*60}")
            print(f"EVALUATING: {model_name} — ORLM Problems")
            print(f"{'='*60}")

            orlm_results = run_orlm_evaluation(
                model_dir, orlm_problems, args.timeout, args.solver
            )

            if orlm_results:
                all_orlm[model_name] = orlm_results

    # --- Print tables ---
    if all_verified:
        print_overall_table(all_verified,
                            "TABLE 1: Verified Problems Overall (all 110)")
        print_per_source_table(all_verified, VERIFIED_DATASETS_ORDER,
                               "TABLE 2: Verified Problems by Source")

    if all_orlm:
        print_orlm_table(all_orlm,
                         "TABLE 3: ORLM Problems")

    # --- Save ---
    save_results_json(all_verified, all_orlm, args.output_json)

    return 0


if __name__ == "__main__":
    exit(main())
