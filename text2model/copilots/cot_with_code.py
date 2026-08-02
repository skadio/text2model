import time

from text2model import utils
from text2model.utils import print

###########################################################
# Two-call Strategy
###########################################################
def run_cot_with_code_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the cot strategy with conditional code validation (only if compilation fails)"""
    try:
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        cot_prompt = utils.load_file('prompts/cot_prompt.txt')
        initial_code = utils.call_api(
            client,
            model,
            cot_prompt.format(
                problem_description=problem_data['description'],
                input_data=effective_input_data
            )
        )

        if not initial_code:
            return False

        current_code = initial_code

        dzn_data = problem.get('data.dzn') or ""
        syntax_error_message = utils.check_syntax(initial_code, dzn_data)

        if syntax_error_message:
            time.sleep(2)

            validation_prompt = utils.load_file('prompts/code_validation_prompt.txt')
            validated_code = utils.call_api(
                client,
                model,
                validation_prompt.format(
                    problem_description=problem_data['description'],
                    input_data=effective_input_data,
                    objective_type=problem_data['objective_type'],
                    final_code=initial_code,
                    syntax_error_message=syntax_error_message
                )
            )

            if validated_code:
                current_code = validated_code

        utils.save_solution(output_dir, problem_identifier, current_code)
        return True

    except Exception as e:
        print(f"Error in two-stage strategy for problem {problem_identifier}: {e}")
        return False
