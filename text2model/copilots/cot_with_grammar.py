import time

from text2model import utils
from text2model.utils import print

###########################################################
# Two-call Strategy
###########################################################
def run_cot_with_grammar_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the CoT + Grammar Validation strategy (2-stage)"""
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

        time.sleep(2)

        current_code = initial_code

        dzn_data = problem.get('data.dzn') or ""
        syntax_error_message = utils.check_syntax(initial_code, dzn_data)

        if syntax_error_message:
            grammar_prompt = utils.load_file('prompts/grammar_validation_prompt.txt')
            minizinc_grammar = utils.load_file('grammar.mzn')

            grammar_corrected_code = utils.call_api(
                client,
                model,
                grammar_prompt.format(
                    problem_description=problem_data['description'],
                    input_data=effective_input_data,
                    current_code=current_code,
                    syntax_error_message=syntax_error_message,
                    minizinc_grammar=minizinc_grammar
                )
            )

            if grammar_corrected_code:
                current_code = grammar_corrected_code

        utils.save_solution(output_dir, problem_identifier, current_code)
        return True

    except Exception as e:
        print(f"Error in CoT + Grammar Check strategy for problem {problem_identifier}: {e}")
        return False
