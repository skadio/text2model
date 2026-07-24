import time

from text2model import utils
from text2model.utils import print

###########################################################
# Four and Five-call Strategy
###########################################################
def run_agents_strategy(client, model, problem, problem_identifier, output_dir, validate=True):
    """Run the agents strategy"""
    try:
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        param_prompt = utils.load_file('prompts/parameter_and_variable_generation_prompt.txt')
        params_vars = utils.call_api(
            client,
            model,
            param_prompt.format(
                problem_description=problem_data['description'],
                input_data=effective_input_data
            )
        )
        if not params_vars:
            return False
        time.sleep(2)

        constraint_prompt = utils.load_file('prompts/constraint_generation_prompt.txt')
        constraints = utils.call_api(
            client,
            model,
            constraint_prompt.format(
                problem_description=problem_data['description'],
                input_data=effective_input_data,
                parameters_and_variables=params_vars
            )
        )
        if not constraints:
            return False
        time.sleep(2)

        objective_prompt = utils.load_file('prompts/objective_generation_prompt.txt')
        objective = utils.call_api(
            client,
            model,
            objective_prompt.format(
                problem_description=problem_data['description'],
                input_data=effective_input_data,
                parameters_and_variables=params_vars,
                constraints=constraints
            )
        )
        if not objective:
            return False
        time.sleep(2)

        code_prompt = utils.load_file('prompts/code_stitching_prompt.txt')
        final_code = utils.call_api(
            client,
            model,
            code_prompt.format(
                problem_description=problem_data['description'],
                input_data=effective_input_data,
                parameters_and_variables=params_vars,
                constraints=constraints,
                objective=objective
            )
        )
        if not final_code:
            return False

        dzn_data = problem.get('data.dzn') or ""
        syntax_error_message = utils.check_syntax(final_code, dzn_data)

        if syntax_error_message and validate:
            time.sleep(2)
            validation_prompt = utils.load_file('prompts/code_validation_prompt.txt')
            validated_code = utils.call_api(
                client,
                model,
                validation_prompt.format(
                    problem_description=problem_data['description'],
                    input_data=effective_input_data,
                    objective_type=problem_data['objective_type'],
                    final_code=final_code,
                    syntax_error_message=syntax_error_message
                )
            )

            if validated_code:
                utils.save_solution(output_dir, problem_identifier, validated_code)
                return True
            return False
        else:
            utils.save_solution(output_dir, problem_identifier, final_code)
            return True

    except Exception as e:
        print(f"Error in agents strategy for problem {problem_identifier}: {e}")
        return False
