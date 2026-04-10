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


def run_minizinc_evaluation(model_code, dzn_string, expected_output, problem_type, timeout=60, solver="highs"):
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
            with tempfile.NamedTemporaryFile(suffix='.dzn', mode='w', delete=False) as output_file:
                output_path = output_file.name

            cmd = [
                "minizinc",
                "--solver", solver,
                "--output-mode", "dzn",
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

            if result.returncode != 0:
                return False, False, result.stderr

            with open(output_path, 'r') as f:
                output_lines = f.readlines()

            if "UNSATISFIABLE" in " ".join(output_lines).upper():
                # Check verification results
                execution_success = True
                solution_success = False
                return execution_success, solution_success, result.stdout

            if output_lines and '---' in output_lines[-1]:
                output_lines = output_lines[:-1]

            verification_constraints = []
            for line in output_lines:
                line = line.strip()
                if line and '=' in line:
                    verification_constraints.append(line.replace(" = ", " = "))

            verification_model = model_code + "\nconstraint\n  " + " /\\\n  ".join(
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

            execution_success = True  # First run was successful
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


# =============================================================================
# DATASET LOADING
# =============================================================================

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
                'hf_index': idx
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
    - cardinal_operations_industryor (identifier: empty)
    - cardinal_operations_nl4opt (identifier: empty)
    
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
                # Filenames: easy_lp_0.mzn, easy_lp_1.mzn, ... OR cardinal_operations_mamo_easy_lp_0.mzn
                key = f"easy_lp_{easylp_idx}"
                problems['easylp'][key] = problem_data
                # Also add with prefix for strategies that use it
                problems['easylp'][f"cardinal_operations_mamo_{key}"] = problem_data
                easylp_idx += 1
            elif identifier == 'complex_lp':
                # Filenames: complex_lp_0.mzn, complex_lp_1.mzn, ... OR cardinal_operations_mamo_complex_lp_0.mzn
                key = f"complex_lp_{complexlp_idx}"
                problems['complexlp'][key] = problem_data
                # Also add with prefix for strategies that use it
                problems['complexlp'][f"cardinal_operations_mamo_{key}"] = problem_data
                complexlp_idx += 1
                
        elif source == 'cardinal_operations_industryor':
            # Filenames: cardinal_operations_industryor_problem_0.mzn, ...
            key = f"cardinal_operations_industryor_problem_{industryor_idx}"
            problems['industryor'][key] = problem_data
            industryor_idx += 1
            
        elif source == 'cardinal_operations_nl4opt':
            # Filenames: cardinal_operations_nl4opt_problem_0.mzn, ...
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
# DIRECTORY-LEVEL EVALUATION
# =============================================================================

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
                solver=solver
            )
            
            metrics["attempted"] += 1
            metrics["execution"] += execution_success
            metrics["solution"] += solution_success
            
            results.append({
                "problem_key": problem_key,
                "source": problem_data.get('source', 'unknown'),
                "execution_success": execution_success,
                "solution_success": solution_success
            })
            
        except Exception as e:
            print(f"\nError evaluating {mzn_file}: {e}")
            traceback.print_exc()
            continue
    
    if metrics["attempted"] == 0:
        return None
    
    metrics["results"] = results
    return metrics


# =============================================================================
# VERIFIED PROBLEMS EVALUATION
# =============================================================================

def evaluate_model_verified(model_name, model_dir, problems, timeout, solver):
    """
    Evaluate verified problems for a single model.
    
    Handles two layouts:
      - Standard:  model_dir/<strategy>/*.mzn
      - gpt-5.2:   model_dir/verified_problems/<strategy>/*.mzn
    
    Returns: {strategy_display_name: {dataset: {attempted, exec_acc, sol_acc}}}
    """
    # Detect layout: if verified_problems/ subfolder exists, use it
    verified_subdir = os.path.join(model_dir, "verified_problems")
    if os.path.isdir(verified_subdir):
        strategies_root = verified_subdir
    else:
        strategies_root = model_dir

    strategies = [d for d in os.listdir(strategies_root)
                  if os.path.isdir(os.path.join(strategies_root, d))]

    if not strategies:
        print(f"  No strategy directories found for {model_name}")
        return {}

    results = {}

    for strategy_folder in sorted(strategies):
        strategy_name = get_strategy_display_name(strategy_folder)
        strategy_path = os.path.join(strategies_root, strategy_folder)

        print(f"\nEvaluating {model_name} / {strategy_name}...")

        eval_result = evaluate_directory(
            strategy_path, problems, timeout, solver,
            desc=f"{model_name}/{strategy_name}"
        )

        if eval_result:
            dataset_metrics = defaultdict(lambda: {"attempted": 0, "execution": 0, "solution": 0})

            for r in eval_result["results"]:
                source = r["source"].lower()
                dataset_metrics[source]["attempted"] += 1
                dataset_metrics[source]["execution"] += r["execution_success"]
                dataset_metrics[source]["solution"] += r["solution_success"]

            results[strategy_name] = {}
            for ds_name, ds_metrics in dataset_metrics.items():
                if ds_metrics["attempted"] > 0:
                    exec_acc = (ds_metrics["execution"] / ds_metrics["attempted"]) * 100
                    sol_acc = (ds_metrics["solution"] / ds_metrics["attempted"]) * 100
                    results[strategy_name][ds_name] = {
                        "attempted": ds_metrics["attempted"],
                        "exec_acc": round(exec_acc, 2),
                        "sol_acc": round(sol_acc, 2)
                    }

    return results


# =============================================================================
# ORLM EVALUATION (gpt-5.2 only)
# =============================================================================

def evaluate_orlm(model_dir, orlm_problems, timeout, solver):
    """
    Evaluate output/<model>/orlm/<dataset>/<strategy>/*.mzn
    
    Returns: {strategy: {dataset: {attempted, exec_acc, sol_acc}}}
    """
    orlm_dir = os.path.join(model_dir, "orlm")
    
    if not os.path.exists(orlm_dir):
        print(f"ORLM directory not found: {orlm_dir}")
        return None
    
    print(f"\n{'='*60}")
    print("EVALUATING: ORLM Problems")
    print(f"{'='*60}")
    
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
            
            if eval_result and eval_result["attempted"] > 0:
                exec_acc = (eval_result["execution"] / eval_result["attempted"]) * 100
                sol_acc = (eval_result["solution"] / eval_result["attempted"]) * 100
                results[strategy_name][dataset_folder] = {
                    "attempted": eval_result["attempted"],
                    "exec_acc": round(exec_acc, 2),
                    "sol_acc": round(sol_acc, 2)
                }
    
    return dict(results)


# =============================================================================
# TABLE PRINTING
# =============================================================================

def print_table(results, datasets_order, title):
    """
    Print table in the requested format:
    strategy; llm_calls; (n, exec%, sol%) per dataset; avg_exec; avg_sol
    """
    print(f"\n{'='*120}")
    print(f"{title}")
    print(f"{'='*120}")
    
    # Header
    header = "Strategy; LLM Calls"
    for ds in datasets_order:
        header += f"; {ds} (n, exec%, sol%)"
    header += "; Avg Exec%; Avg Sol%"
    print(header)
    print("-" * 120)
    
    # Rows in order
    for strategy in STRATEGIES_ORDER:
        if strategy not in results:
            continue
        
        llm_calls = get_llm_calls(strategy)
        row = f"{strategy}; {llm_calls}"
        
        total_attempted = 0
        total_exec = 0
        total_sol = 0
        
        for ds in datasets_order:
            if ds in results[strategy]:
                data = results[strategy][ds]
                n = data["attempted"]
                exec_acc = data["exec_acc"]
                sol_acc = data["sol_acc"]
                row += f"; ({n}, {exec_acc}, {sol_acc})"
                total_attempted += n
                total_exec += n * exec_acc / 100
                total_sol += n * sol_acc / 100
            else:
                row += "; (--, --, --)"
        
        # Weighted averages
        if total_attempted > 0:
            avg_exec = round((total_exec / total_attempted) * 100, 2)
            avg_sol = round((total_sol / total_attempted) * 100, 2)
        else:
            avg_exec = "--"
            avg_sol = "--"
        
        row += f"; {avg_exec}; {avg_sol}"
        print(row)


# =============================================================================
# LEADERBOARD (verified problems only)
# =============================================================================

def create_leaderboard(all_verified_results, output_dir):
    """
    Create leaderboard.csv from verified-problem results across all models.
    
    all_verified_results: {model_name: {strategy: {dataset: {attempted, exec_acc, sol_acc}}}}
    """
    entries = []

    for model_name, strategy_results in all_verified_results.items():
        for strategy_name, dataset_results in strategy_results.items():
            total_attempted = 0
            total_exec = 0
            total_sol = 0

            for ds_metrics in dataset_results.values():
                n = ds_metrics["attempted"]
                total_attempted += n
                total_exec += n * ds_metrics["exec_acc"] / 100
                total_sol += n * ds_metrics["sol_acc"] / 100

            if total_attempted > 0:
                exec_acc = round((total_exec / total_attempted) * 100, 2)
                sol_acc = round((total_sol / total_attempted) * 100, 2)
                avg_score = round((exec_acc + sol_acc) / 2, 2)
            else:
                exec_acc = sol_acc = avg_score = 0.0

            entries.append({
                "model": model_name,
                "strategy": strategy_name,
                "execution_accuracy": exec_acc,
                "solution_accuracy": sol_acc,
                "average_score": avg_score,
                "problems_attempted": total_attempted,
                "problems_solved": int(total_sol),
                "evaluation_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            })

    if not entries:
        print("No verified results to build leaderboard from")
        return None

    leaderboard = pd.DataFrame(entries)
    leaderboard = leaderboard.sort_values("average_score", ascending=False)

    results_dir = os.path.join(output_dir, "evaluation_results")
    os.makedirs(results_dir, exist_ok=True)
    leaderboard_path = os.path.join(results_dir, "leaderboard.csv")
    leaderboard.to_csv(leaderboard_path, index=False)

    print(f"\nLeaderboard saved to {leaderboard_path}")
    print("\n" + leaderboard.to_string(index=False))

    return leaderboard


def main():
    parser = argparse.ArgumentParser(description='Evaluate Text2Zinc MiniZinc code generation')
    parser.add_argument('--output-dir', default='output',
                        help='Base output directory containing model folders')
    parser.add_argument('--model',
                        help='Specific model to evaluate (e.g., gpt-4, gpt-5.2)')
    parser.add_argument('--strategy',
                        help='Specific strategy to evaluate')
    parser.add_argument('--timeout', type=int, default=120,
                        help='Timeout in seconds for each problem')
    parser.add_argument('--solver', default='highs',
                        help='MiniZinc solver to use')
    parser.add_argument('--eval-orlm', action='store_true', default=True,
                        help='Also evaluate and print ORLM results (default: True)')
    parser.add_argument('--no-eval-orlm', action='store_false', dest='eval_orlm',
                        help='Skip ORLM evaluation')
    parser.add_argument('--create-leaderboard-only', action='store_true',
                        help='Only create leaderboard from existing results')
    parser.add_argument('--output-json', default='evaluation_results.json',
                        help='Output JSON file for detailed results')

    args = parser.parse_args()

    # Verify MiniZinc
    if not verify_minizinc_installation():
        return 1

    # Discover models
    if not os.path.exists(args.output_dir):
        print(f"Output directory not found: {args.output_dir}")
        return 1

    if args.model:
        models_to_evaluate = [args.model]
    else:
        models_to_evaluate = [d for d in os.listdir(args.output_dir)
                              if os.path.isdir(os.path.join(args.output_dir, d))
                              and d != "evaluation_results"]

    # Print config
    print(f"\n{'='*60}")
    print("EVALUATION CONFIGURATION")
    print(f"{'='*60}")
    print(f"Output directory: {args.output_dir}")
    print(f"Models: {', '.join(models_to_evaluate)}")
    print(f"Strategy filter: {args.strategy or 'All'}")
    print(f"Evaluate ORLM: {args.eval_orlm}")
    print(f"Timeout: {args.timeout}s")
    print(f"Solver: {args.solver}")
    print(f"{'='*60}")

    # Load problems
    verified_problems = load_verified_problems()
    if not verified_problems:
        print("Failed to load verified problems")
        return 1

    orlm_problems = None
    if args.eval_orlm:
        orlm_problems = load_orlm_problems()

    # Evaluate each model
    all_verified_results = {}  # model -> {strategy -> {dataset -> metrics}}
    all_orlm_results = {}      # model -> {strategy -> {dataset -> metrics}}

    for model_name in models_to_evaluate:
        model_dir = os.path.join(args.output_dir, model_name)
        if not os.path.exists(model_dir):
            print(f"Model directory not found: {model_dir}")
            continue

        print(f"\n{'='*60}")
        print(f"EVALUATING MODEL: {model_name} (Verified Problems)")
        print(f"{'='*60}")

        verified_results = evaluate_model_verified(
            model_name, model_dir, verified_problems, args.timeout, args.solver
        )

        if verified_results:
            all_verified_results[model_name] = verified_results
            print_table(verified_results, VERIFIED_DATASETS_ORDER,
                        f"Verified Problems - {model_name}")

        # ORLM: only if flag is set and the model has an orlm/ subfolder
        if args.eval_orlm and orlm_problems and os.path.isdir(os.path.join(model_dir, "orlm")):
            orlm_results = evaluate_orlm(model_dir, orlm_problems, args.timeout, args.solver)
            if orlm_results:
                all_orlm_results[model_name] = orlm_results
                print_table(orlm_results, ORLM_DATASETS_ORDER,
                            f"ORLM Problems - {model_name}")

    # Leaderboard — verified problems only
    if all_verified_results:
        create_leaderboard(all_verified_results, args.output_dir)

    # Save full JSON
    all_json = {
        "verified_results": all_verified_results,
        "orlm_results": all_orlm_results,
        "evaluation_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }
    with open(args.output_json, 'w') as f:
        json.dump(all_json, f, indent=2)
    print(f"\nDetailed results saved to: {args.output_json}")

    return 0


if __name__ == "__main__":
    exit(main())
