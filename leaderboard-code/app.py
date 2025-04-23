import os
from datetime import datetime

import gradio as gr
import pandas as pd

from evaluation_script import (HF_DATASET_NAME, RESULTS_PATH, SUBMISSIONS_PATH,
                               evaluate_model, load_problems_from_hf,
                               verify_minizinc_installation)

# Ensure submission and results directories exist
os.makedirs(SUBMISSIONS_PATH, exist_ok=True)
os.makedirs(RESULTS_PATH, exist_ok=True)

# Available solvers
SOLVERS = ["highs", "gecode", "chuffed", "gurobi"]

def get_available_models():
    """Get a list of models that have been submitted."""
    if not os.path.exists(SUBMISSIONS_PATH):
        return []
    return sorted(os.listdir(SUBMISSIONS_PATH))

def get_leaderboard_df():
    """Generate leaderboard dataframe from results."""
    if not os.path.exists(RESULTS_PATH):
        return pd.DataFrame()
    
    results = []
    for model_dir in os.listdir(RESULTS_PATH):
        summary_path = f"{RESULTS_PATH}/{model_dir}/summary.json"
        if os.path.exists(summary_path):
            with open(summary_path, 'r') as f:
                result = pd.read_json(f, typ='series')
                results.append(result)
    
    if not results:
        return pd.DataFrame()
    
    df = pd.DataFrame(results)
    return df.sort_values(by="average_score", ascending=False).reset_index(drop=True)

def update_table(search_query=""):
    """Filter and update the leaderboard table."""
    df = get_leaderboard_df()
    
    if not df.empty and search_query:
        df = df[df["model_name"].str.contains(search_query, case=False)]
    
    # Select and rename columns for display
    display_columns = {
        "model_name": "Model Name",
        "satisfaction_execution_accuracy": "Satisfaction Exec Acc (%)",
        "satisfaction_solution_accuracy": "Satisfaction Sol Acc (%)",
        "optimization_execution_accuracy": "Optimization Exec Acc (%)",
        "optimization_solution_accuracy": "Optimization Sol Acc (%)",
        "execution_accuracy": "Overall Exec Acc (%)",
        "solution_accuracy": "Overall Sol Acc (%)",
        "average_score": "Average Score (%)",
        "satisfaction_problems": "Satisfaction Problems",
        "optimization_problems": "Optimization Problems",
        "problems_solved": "Total Problems Solved"
    }
    
    display_df = df[display_columns.keys()].rename(columns=display_columns)
    
    return display_df

def process_upload(files, model_name):
    """Handle model file uploads."""
    if not model_name:
        return "Error: Model name is required", gr.update(choices=get_available_models())
    if not files:
        return "Error: No files uploaded", gr.update()
        
    submission_dir = f"{SUBMISSIONS_PATH}/{model_name}"
    os.makedirs(submission_dir, exist_ok=True)
    
    file_count = 0
    for file in files:
        filename = os.path.basename(file.name)
        if not filename.endswith('.mzn'):
            continue
            
        target_path = f"{submission_dir}/{filename}"
        with open(target_path, 'wb') as f:
            f.write(file.read())
        file_count += 1
    
    if file_count == 0:
        return "Error: No valid MiniZinc (.mzn) files found", gr.update()
    
    return f"Successfully uploaded {file_count} model files", gr.update(choices=get_available_models())

def evaluate_submission(model_name, solver, timeout):
    """Evaluate a submission using the evaluation script."""
    if not model_name:
        return "Error: Model name is required"
        
    # Verify MiniZinc is installed
    if not verify_minizinc_installation():
        return "Error: MiniZinc not found. Please install MiniZinc first."
    
    # Run evaluation with specified solver and timeout
    results = evaluate_model(model_name, timeout=timeout, solver=solver)
    if not results:
        return "Error: Evaluation failed. Check if model files exist and are valid."
    
    return f"""Evaluation Complete:

Solver Used: {solver}
Timeout: {timeout} seconds

Satisfaction Problems:
- Execution Accuracy: {results['satisfaction_execution_accuracy']}%
- Solution Accuracy: {results['satisfaction_solution_accuracy']}%
- Problems Attempted: {results['satisfaction_problems']}

Optimization Problems:
- Execution Accuracy: {results['optimization_execution_accuracy']}%
- Solution Accuracy: {results['optimization_solution_accuracy']}%
- Problems Attempted: {results['optimization_problems']}

Overall Performance:
- Execution Accuracy: {results['execution_accuracy']}%
- Solution Accuracy: {results['solution_accuracy']}%
- Average Score: {results['average_score']}%
- Total Problems Solved: {results['problems_solved']}/{results['problems_attempted']}"""

def load_problem_stats():
    """Get statistics about available problems."""
    problems = load_problems_from_hf()
    problem_identifiers = [p['problem_identifier'] for p in problems.values()]
    
    # Count satisfaction problems
    satisfaction_count = sum(1 for p in problems.values() if p['problem_type'] == 'satisfaction')
    
    # Count different types of optimization problems
    optimization_types = {}
    for p in problems.values():
        if p['problem_type'] != 'satisfaction':
            opt_type = p['problem_type']
            optimization_types[opt_type] = optimization_types.get(opt_type, 0) + 1
    
    # Total optimization count
    optimization_count = sum(optimization_types.values())
    
    return {
        "Total Problems": len(problems),
        "Satisfaction Problems": satisfaction_count,
        "Optimization Problems": {
            "Total": optimization_count,
            "By Type": optimization_types
        },
        "Sample Problem IDs": problem_identifiers[:5]
    }

# Build Gradio Interface
with gr.Blocks(title="MiniZinc Model Leaderboard") as demo:
    gr.HTML("<h1>🏆 MiniZinc Model Evaluation Leaderboard</h1>")
    
    with gr.Row():
        with gr.Column(scale=2):
           gr.Markdown(f"""
            ## About
            This leaderboard tracks AI models' performance in generating MiniZinc solutions.
            - Dataset: [{HF_DATASET_NAME}](https://huggingface.co/datasets/{HF_DATASET_NAME})
            - Metrics include `execution accuracy` and `solution accuracy` for each problem type
            - Multiple solvers available: {', '.join(SOLVERS)}

            ## Submission Instructions
            1. Under `submissions` folder create a new folder with a name representing your model
               - This name will appear in the leaderboard
               - Choose a descriptive and unique name
            
            2. In your model folder, include:
               - Solution files for **all problems** in the dataset
               - Each solution file should be named exactly as the problem ID with .mzn extension
               - A **README.md** file describing your approach and model details:
                 * Model/Approach name
                 * Brief description of the solution approach
                 * Link to paper/code (if applicable)
                 * Author information
            
            3. Test your submission locally before creating a PR:
               - Run `python evaluation_script.py --model your_model_name` to verify solutions
               - Run `python app.py` to check leaderboard integration
               - Ensure the metrics are calculated correctly
            """)
        with gr.Column(scale=1):
            stats = gr.JSON(value=load_problem_stats(), label="Dataset Statistics")
    
    with gr.Tabs():
        # Leaderboard Tab
        with gr.Tab("Leaderboard"):
            search = gr.Textbox(label="Search Models", placeholder="Search...")
            
            leaderboard = gr.DataFrame(
                value=get_leaderboard_df(),
                headers=[
                    "Model Name",
                    "Satisfaction Exec Acc (%)", "Satisfaction Sol Acc (%)",
                    "Optimization Exec Acc (%)", "Optimization Sol Acc (%)",
                    "Overall Exec Acc (%)", "Overall Sol Acc (%)",
                    "Average Score (%)",
                    "Satisfaction Problems", "Optimization Problems",
                    "Total Problems Solved"
                ],
                interactive=False
            )
            
            # Update table on search change
            search.change(update_table, [search], leaderboard)
        
        # Submission Tab
        with gr.Tab("Submit & Evaluate"):
            with gr.Row():
                with gr.Column():
                    gr.Markdown("### Upload New Model")
                    new_model_name = gr.Textbox(label="New Model Name")
                    files = gr.File(
                        file_count="multiple",
                        label="Upload MiniZinc Files (.mzn)",
                        file_types=[".mzn"]
                    )
                    upload_btn = gr.Button("Upload Files")
                    upload_output = gr.Textbox(label="Upload Status")
                
                with gr.Column():
                    gr.Markdown("### Evaluate Model")
                    existing_model = gr.Dropdown(
                        choices=get_available_models(),
                        label="Select Model",
                        info="Choose from uploaded models"
                    )
                    solver = gr.Dropdown(
                        choices=SOLVERS,
                        value="highs",
                        label="MiniZinc Solver",
                        info="Select the solver to use for evaluation"
                    )
                    timeout = gr.Slider(
                        minimum=10,
                        maximum=300,
                        value=60,
                        step=10,
                        label="Timeout (seconds)",
                        info="Maximum time allowed per problem"
                    )
                    evaluate_btn = gr.Button("Evaluate Model")
            
            eval_output = gr.Textbox(label="Evaluation Results")
            
            # Connect components
            upload_btn.click(
                process_upload,
                inputs=[files, new_model_name],
                outputs=[upload_output, existing_model]
            )
            
            evaluate_btn.click(
                evaluate_submission,
                inputs=[existing_model, solver, timeout],
                outputs=eval_output
            )


if __name__ == "__main__":
    demo.launch(
        server_name="0.0.0.0", 
        server_port=7860
    )