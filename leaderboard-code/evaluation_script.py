#!/usr/bin/env python3
import argparse
import ast
import glob
import json
import os
import re
import subprocess
import tempfile
from datetime import datetime

import pandas as pd
from datasets import Dataset, load_dataset

# Get the absolute path of the directory containing the script
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# Define paths relative to the base directory
SUBMISSIONS_PATH = os.path.join(BASE_DIR, "submissions")
RESULTS_PATH = os.path.join(BASE_DIR, "results")

HF_DATASET_NAME = "skadio/text2zinc"

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

def load_problems_from_hf():
    """Load problems from HuggingFace dataset."""
    try:
        print(f"Loading problems from HuggingFace dataset: {HF_DATASET_NAME}")
        dataset = load_dataset(HF_DATASET_NAME, download_mode="FORCE_REDOWNLOAD")
        if 'train' in dataset:
            dataset = dataset['train']
            
        problems = {}
        for idx, example in enumerate(dataset):
            problem_id = example.get('problem_id', f"problem_{idx}")
            problems[problem_id] = {
                'dzn_string': example['data.dzn'],
                'expected_output': example['output.json'],
                'problem_type': ast.literal_eval(example['input.json'])['metadata']['objective'],
                'problem_identifier': ast.literal_eval(example['input.json'])['metadata']['identifier']
            }
        
        print(f"Successfully loaded {len(problems)} problems from dataset")
        return problems
    except Exception as e:
        print(f"Error loading problems from HuggingFace: {e}")
        return {}

def get_model_code(model_name, problem_id):
    """Get the model code from submission directory."""
    model_path = f"{SUBMISSIONS_PATH}/{model_name}/{problem_id}.mzn"
    if os.path.exists(model_path):
        with open(model_path, 'r') as f:
            return f.read()
    return None

def run_minizinc_evaluation(model_code, dzn_string, expected_output, problem_type, timeout=10, solver="highs"):
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
            
            # ==> else proceed further
            
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
                print(f"Warning: Failed to cleanup temporary file {path}: {e}")
        if problem_type == "satisfaction" and 'verif_path' in locals():
            try:
                os.unlink(verif_path)
            except Exception as e:
                print(f"Warning: Failed to cleanup verification file: {e}")

def evaluate_model(model_name, timeout, solver):
    """Evaluate a model's performance."""
    model_dir = f"{SUBMISSIONS_PATH}/{model_name}"
    if not os.path.exists(model_dir):
        print(f"Error: Model directory {model_dir} not found")
        return None
    
    # Load problems from HuggingFace
    problems = load_problems_from_hf()
    
    if not problems:
        print(f"Error: No problems found for evaluation")
        return None
    
    print(f"Evaluating {model_name} on {len(problems)} problems...")
    results = []
    
    # Track metrics separately for satisfaction and optimization problems
    satisfaction_metrics = {"attempted": 0, "execution": 0, "solution": 0}
    optimization_metrics = {"attempted": 0, "execution": 0, "solution": 0}
    
    # Evaluate each problem
    for problem_id, problem_data in problems.items():
        problem_id = problem_data['problem_identifier']
        model_code = get_model_code(model_name, problem_id)
        problem_type = problem_data['problem_type']
        
        if not model_code:
            print(f"  - {problem_id}: ✗ Model file not found")
            continue
            
        print(f"  - {problem_id} ({problem_type}): Running evaluation...", end="", flush=True)
        execution_success, solution_success, output = run_minizinc_evaluation(
            model_code,
            problem_data['dzn_string'],
            problem_data['expected_output'],
            problem_type,
            timeout=timeout,
            solver=solver
        )
        
        status = "✓" if solution_success else ("!" if execution_success else "✗")
        print(f" {status}")
        
        # Update metrics based on problem type
        metrics = satisfaction_metrics if problem_type == "satisfaction" else optimization_metrics
        metrics["attempted"] += 1
        metrics["execution"] += execution_success
        metrics["solution"] += solution_success
        
        results.append({
            "problem_id": problem_id,
            "problem_type": problem_type,
            "execution_success": execution_success,
            "solution_success": solution_success,
            "output": output[:1000] if len(output) > 1000 else output
        })
    
    # Calculate combined and separate metrics
    total_attempted = len(results)
    if total_attempted == 0:
        print(f"Error: No problems were evaluated for {model_name}")
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


def save_results(results, model_name):
    """Save evaluation results to disk."""
    result_dir = f"{RESULTS_PATH}/{model_name}"
    os.makedirs(result_dir, exist_ok=True)
    
    # Save detailed results
    with open(f"{result_dir}/detailed_results.json", 'w') as f:
        json.dump(results["detailed_results"], f, indent=2)
    
    # Save summary (without detailed results)
    summary = {k: v for k, v in results.items() if k != "detailed_results"}
    with open(f"{result_dir}/summary.json", 'w') as f:
        json.dump(summary, f, indent=2)
    
    print(f"\nResults saved to {result_dir}")
    return result_dir

def update_leaderboard():
    """Update the main leaderboard file."""
    # Gather all summary files
    summary_files = glob.glob(f"{RESULTS_PATH}/*/summary.json")
    
    if not summary_files:
        print("No evaluation results found")
        return
    
    entries = []
    for summary_file in summary_files:
        with open(summary_file, 'r') as f:
            data = json.load(f)
            entries.append({
                "model_name": data["model_name"],
                "model_type": data.get("model_type", "Unknown"),
                "submission_date": data.get("evaluation_date", "Unknown"),
                "execution_accuracy": data["execution_accuracy"],
                "solution_accuracy": data["solution_accuracy"],
                "average_score": data["average_score"],
                "problems_attempted": data["problems_attempted"],
                "problems_solved": data["problems_solved"]
            })
    
    # Create dataframe and sort by average score
    leaderboard = pd.DataFrame(entries)
    leaderboard = leaderboard.sort_values("average_score", ascending=False)
    
    # Save to CSV
    leaderboard.to_csv(f"{RESULTS_PATH}/leaderboard.csv", index=False)
    print(f"Leaderboard updated with {len(entries)} entries")
    return leaderboard

def main():
    global HF_DATASET_NAME
    
    parser = argparse.ArgumentParser(description="Evaluate MiniZinc models using HuggingFace dataset")
    parser.add_argument("--model", required=True, help="Name of the model to evaluate")
    parser.add_argument("--timeout", type=int, default=60,
                        help="Timeout in seconds for each problem evaluation")
    parser.add_argument("--solver", type=str, default="highs",
                        help="Solver for MiniZinc")
    
    args = parser.parse_args()
    
    # Ensure directories exist
    for path in [SUBMISSIONS_PATH, RESULTS_PATH]:
        os.makedirs(path, exist_ok=True)
    
    # Verify MiniZinc installation
    if not verify_minizinc_installation():
        return 1
    
    # Evaluate model
    results = evaluate_model(args.model, args.timeout, args.solver)
    if not results:
        return 1
    
    # Save results
    save_results(results, args.model)
    
    # Print summary
    print("\nEvaluation Summary:")
    print(f"Model: {args.model}")
    print(f"Problems Attempted: {results['problems_attempted']}")
    print(f"Problems Solved: {results['problems_solved']}")
    print(f"Satisfaction Problems Execution Accuracy: {results['satisfaction_execution_accuracy']}%")
    print(f"Satisfaction Problems Solution Accuracy: {results['satisfaction_solution_accuracy']}%")
    print(f"Optimization Problems Execution Accuracy: {results['optimization_execution_accuracy']}%")
    print(f"Optimization Problems Solution Accuracy: {results['optimization_solution_accuracy']}%")
    print(f"Average Score: {results['average_score']}%")
    
    return 0

if __name__ == "__main__":
    exit(main())