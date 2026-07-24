from text2model import utils
from text2model.utils import print

###########################################################
# Single-call Strategy
###########################################################
def run_baseline_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the baseline single-prompt strategy"""
    try:
        prompt = utils.create_baseline_prompt(problem)
        solution = utils.call_api(client, model, prompt)

        if solution:
            utils.save_solution(output_dir, problem_identifier, solution)
            return True
        return False
    except Exception as e:
        print(f"Error in baseline strategy for problem {problem_identifier}: {e}")
        return False
