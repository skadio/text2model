import argparse
import ast
import json
import os
import re
import subprocess
import tempfile
from datetime import datetime

import pandas as pd
from datasets import load_dataset
from tqdm import tqdm


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


def load_problems_from_dataset():
    """Load problems from HuggingFace dataset."""
    try:
        print("Loading problems from HuggingFace dataset...")
        dataset = load_dataset("skadio/text2zinc")['train']

        problems = {}
        for idx, example in enumerate(dataset):
            input_data = ast.literal_eval(example['input.json'])
            problem_identifier = input_data['metadata']['identifier']
            problems[problem_identifier] = {
                'dzn_string': example['data.dzn'],
                'expected_output': example['output.json'],
                'problem_type': input_data['metadata']['objective'],
                'problem_identifier': problem_identifier,
                'index': idx
            }

        print(f"Successfully loaded {len(problems)} problems from dataset")
        return problems
    except Exception as e:
        print(f"Error loading problems from HuggingFace: {e}")
        return {}


def get_model_code(file_path):
    """Read model code from file."""
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            return f.read()
    return None


def run_minizinc_evaluation(model_code, dzn_string, expected_output, problem_type, timeout=60, solver="highs"):
    """Run MiniZinc model with dzn string and compare output with expected solution."""
    try:
        # Create temporary files for model and data
        with tempfile.NamedTemporaryFile(suffix='.mzn', mode='w', delete=False) as model_file:
            model_file.write(model_code)
            model_path = model_file.name

        with tempfile.NamedTemporaryFile(suffix='.dzn', mode='w', delete=False) as data_file:
            data_file.write(dzn_string)
            data_path = data_file.name

        if problem_type == "satisfaction":
            # First run: Generate solution as DZN
            with tempfile.NamedTemporaryFile(suffix='.dzn', mode='w', delete=False) as output_file:
                output_path = output_file.name

            # Run minizinc for satisfaction problem
            result = subprocess.run([
                "minizinc",
                "--solver", solver,
                "--output-mode", "dzn",
                model_path,
                data_path,
                "-o", output_path
            ],
                capture_output=True,
                text=True,
                timeout=timeout
            )

            # Check first execution
            if result.returncode != 0:
                return False, False, result.stderr

            # Read the output DZN and prepare verification model
            with open(output_path, 'r') as f:
                output_lines = f.readlines()

            if "UNSATISFIABLE" in " ".join(output_lines).upper():
                # Check verification results
                execution_success = True
                solution_success = False
                return execution_success, solution_success, result.stdout

            # Remove the last line if it contains dashes
            if output_lines and '---' in output_lines[-1]:
                output_lines = output_lines[:-1]

            # Create verification constraints
            verification_constraints = []
            for line in output_lines:
                line = line.strip()
                if line and '=' in line:
                    verification_constraints.append(line.replace(" = ", " = "))

            # Create verification model
            verification_model = model_code + "\nconstraint\n  " + " /\\\n  ".join(
                [c.rstrip(';') for c in verification_constraints]
            ) + ";\n"

            # Write verification model to new file
            with tempfile.NamedTemporaryFile(suffix='.mzn', mode='w', delete=False) as verif_file:
                verif_file.write(verification_model)
                verif_path = verif_file.name

            # Run verification
            verif_result = subprocess.run([
                "minizinc",
                "--solver", solver,
                verif_path,
                data_path
            ],
                capture_output=True,
                text=True,
                timeout=timeout
            )

            # Check verification results
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

            # Run minizinc with JSON output
            result = subprocess.run([
                "minizinc",
                "--solver", solver,
                "--output-objective",
                "--output-mode", "json",
                model_path,
                data_path,
                "-o", output_path
            ],
                capture_output=True,
                text=True,
                timeout=timeout
            )

            # Check if execution was successful
            execution_success = result.returncode == 0

            if execution_success:
                # Read the JSON output file
                with open(output_path, 'r') as f:
                    output_text = f.read()
                json_match = re.search(r'{.*}', output_text, re.DOTALL)
                if json_match:
                    json_str = json_match.group(0)
                    output_json = json.loads(json_str)
                else:
                    return execution_success, False, "No objective value found in output"

                # Extract objective value from JSON
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
        for path in [model_path, data_path, output_path]:
            try:
                if os.path.exists(path):
                    os.unlink(path)
            except Exception as e:
                pass
        if problem_type == "satisfaction" and 'verif_path' in locals():
            try:
                os.unlink(verif_path)
            except Exception as e:
                pass


def evaluate_strategy(model_name, strategy_name, output_dir, problems, timeout, solver):
    """Evaluate a specific strategy's performance."""
    strategy_dir = os.path.join(output_dir, model_name, strategy_name)

    if not os.path.exists(strategy_dir):
        print(f"  Strategy directory not found: {strategy_dir}")
        return None

    print(f"\nEvaluating {model_name}/{strategy_name}...")
    results = []

    # Track metrics separately for satisfaction and optimization problems
    satisfaction_metrics = {"attempted": 0, "execution": 0, "solution": 0}
    optimization_metrics = {"attempted": 0, "execution": 0, "solution": 0}

    # Get all model files in the strategy directory
    model_files = sorted([f for f in os.listdir(strategy_dir) if f.endswith('.mzn')])

    # Evaluate each model file
    for model_file in tqdm(model_files, desc=f"{strategy_name} progress"):
        # Extract problem identifier from filename
        problem_identifier = model_file.replace('.mzn', '')

        if problem_identifier not in problems:
            continue

        problem_data = problems[problem_identifier]
        model_code = get_model_code(os.path.join(strategy_dir, model_file))
        problem_type = problem_data['problem_type']

        if not model_code:
            continue

        execution_success, solution_success, output = run_minizinc_evaluation(
            model_code,
            problem_data['dzn_string'],
            problem_data['expected_output'],
            problem_type,
            timeout=timeout,
            solver=solver
        )

        # Update metrics based on problem type
        metrics = satisfaction_metrics if problem_type == "satisfaction" else optimization_metrics
        metrics["attempted"] += 1
        metrics["execution"] += execution_success
        metrics["solution"] += solution_success

        results.append({
            "problem_id": problem_identifier,
            "problem_type": problem_type,
            "execution_success": execution_success,
            "solution_success": solution_success,
            "timeout": timeout,
            "solver": solver,
            "output": output[:1000] if len(output) > 1000 else output
        })

    # Calculate combined and separate metrics
    total_attempted = len(results)
    if total_attempted == 0:
        print(f"  No problems evaluated for {strategy_name}")
        return None

    def calc_accuracy(metrics):
        if metrics["attempted"] == 0:
            return 0, 0
        exec_acc = (metrics["execution"] / metrics["attempted"]) * 100
        sol_acc = (metrics["solution"] / metrics["attempted"]) * 100
        return exec_acc, sol_acc

    # Calculate separate metrics
    sat_exec_acc, sat_sol_acc = calc_accuracy(satisfaction_metrics)
    opt_exec_acc, opt_sol_acc = calc_accuracy(optimization_metrics)

    # Calculate overall metrics
    total_exec = satisfaction_metrics["execution"] + optimization_metrics["execution"]
    total_sol = satisfaction_metrics["solution"] + optimization_metrics["solution"]
    overall_exec_acc = (total_exec / total_attempted) * 100
    overall_sol_acc = (total_sol / total_attempted) * 100
    average_score = (overall_exec_acc + overall_sol_acc) / 2

    # Create summary
    summary = {
        "model_name": model_name,
        "strategy_name": strategy_name,
        "evaluation_date": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "execution_accuracy": round(overall_exec_acc, 2),
        "solution_accuracy": round(overall_sol_acc, 2),
        "average_score": round(average_score, 2),
        "satisfaction_execution_accuracy": round(sat_exec_acc, 2),
        "satisfaction_solution_accuracy": round(sat_sol_acc, 2),
        "optimization_execution_accuracy": round(opt_exec_acc, 2),
        "optimization_solution_accuracy": round(opt_sol_acc, 2),
        "problems_attempted": total_attempted,
        "problems_solved": total_sol,
        "satisfaction_problems": satisfaction_metrics["attempted"],
        "optimization_problems": optimization_metrics["attempted"],
        "detailed_results": results
    }

    return summary


def save_results(results, output_dir, model_name, strategy_name):
    """Save evaluation results to disk."""
    result_dir = os.path.join(output_dir, "evaluation_results", model_name, strategy_name)
    os.makedirs(result_dir, exist_ok=True)

    # Save detailed results
    with open(os.path.join(result_dir, "detailed_results.json"), 'w') as f:
        json.dump(results["detailed_results"], f, indent=2)

    # Save summary (without detailed results)
    summary = {k: v for k, v in results.items() if k != "detailed_results"}
    with open(os.path.join(result_dir, "summary.json"), 'w') as f:
        json.dump(summary, f, indent=2)

    return result_dir


def create_leaderboard(output_dir):
    """Create a leaderboard from all evaluation results."""
    results_dir = os.path.join(output_dir, "evaluation_results")
    if not os.path.exists(results_dir):
        print("No evaluation results found")
        return None

    entries = []

    # Gather all summary files
    for model_name in os.listdir(results_dir):
        model_dir = os.path.join(results_dir, model_name)
        if not os.path.isdir(model_dir):
            continue

        for strategy_name in os.listdir(model_dir):
            strategy_dir = os.path.join(model_dir, strategy_name)
            summary_file = os.path.join(strategy_dir, "summary.json")

            if os.path.exists(summary_file):
                with open(summary_file, 'r') as f:
                    data = json.load(f)
                    entries.append({
                        "model": model_name,
                        "strategy": strategy_name,
                        "execution_accuracy": data["execution_accuracy"],
                        "solution_accuracy": data["solution_accuracy"],
                        "average_score": data["average_score"],
                        "problems_attempted": data["problems_attempted"],
                        "problems_solved": data["problems_solved"],
                        "evaluation_date": data["evaluation_date"]
                    })

    if not entries:
        print("No evaluation results found")
        return None

    # Create dataframe and sort by average score
    leaderboard = pd.DataFrame(entries)
    leaderboard = leaderboard.sort_values("average_score", ascending=False)

    # Save to CSV
    leaderboard_path = os.path.join(results_dir, "leaderboard.csv")
    leaderboard.to_csv(leaderboard_path, index=False)

    print(f"\nLeaderboard saved to {leaderboard_path}")
    print("\n" + leaderboard.to_string(index=False))

    return leaderboard


def main():
    parser = argparse.ArgumentParser(description='Evaluate generated MiniZinc code')
    parser.add_argument('--output-dir', default='output', help='Base output directory')
    parser.add_argument('--model', help='Specific model to evaluate (e.g., gpt-4)')
    parser.add_argument('--strategy', help='Specific strategy to evaluate')
    parser.add_argument('--timeout', type=int, default=120, help='Timeout in seconds for each problem')
    parser.add_argument('--solver', default='highs', help='MiniZinc solver to use')
    parser.add_argument('--create-leaderboard-only', action='store_true',
                        help='Only create leaderboard from existing results')

    args = parser.parse_args()

    # Create leaderboard only if requested
    if args.create_leaderboard_only:
        create_leaderboard(args.output_dir)
        return 0

    # Verify MiniZinc installation
    if not verify_minizinc_installation():
        return 1

    # Load problems
    problems = load_problems_from_dataset()
    if not problems:
        return 1

    # Get list of models and strategies to evaluate
    if not os.path.exists(args.output_dir):
        print(f"Output directory not found: {args.output_dir}")
        return 1

    models_to_evaluate = []
    if args.model:
        models_to_evaluate = [args.model]
    else:
        models_to_evaluate = [d for d in os.listdir(args.output_dir)
                              if os.path.isdir(os.path.join(args.output_dir, d))
                              and d != "evaluation_results"]

    # Evaluate each model and strategy
    all_results = []
    for model_name in models_to_evaluate:
        model_dir = os.path.join(args.output_dir, model_name)

        strategies_to_evaluate = []
        if args.strategy:
            strategies_to_evaluate = [args.strategy]
        else:
            strategies_to_evaluate = [d for d in os.listdir(model_dir)
                                      if os.path.isdir(os.path.join(model_dir, d))]

        for strategy_name in strategies_to_evaluate:
            results = evaluate_strategy(
                model_name,
                strategy_name,
                args.output_dir,
                problems,
                args.timeout,
                args.solver
            )

            if results:
                save_results(results, args.output_dir, model_name, strategy_name)
                all_results.append({
                    "model": model_name,
                    "strategy": strategy_name,
                    "average_score": results["average_score"]
                })

                print(f"\nSummary for {model_name}/{strategy_name}:")
                print(f"  Execution Accuracy: {results['execution_accuracy']}%")
                print(f"  Solution Accuracy: {results['solution_accuracy']}%")
                print(f"  Average Score: {results['average_score']}%")

    # Create leaderboard
    if all_results:
        create_leaderboard(args.output_dir)

    return 0


if __name__ == "__main__":
    exit(main())
