from text2model import utils
from text2model.utils import print

###########################################################
# Two-call Strategy
###########################################################
def run_cot_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the Chain of Thought strategy (single-stage)"""
    try:
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        cot_prompt = utils.load_file('prompts/cot_prompt.txt')
        code = utils.call_api(
            client,
            model,
            cot_prompt.format(
                problem_description=problem_data['description'],
                input_data=effective_input_data
            )
        )

        if not code:
            return False

        utils.save_solution(output_dir, problem_identifier, code)
        return True

    except Exception as e:
        print(f"Error in CoT strategy for problem {problem_identifier}: {e}")
        return False
