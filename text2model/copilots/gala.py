from text2model import utils
from text2model.utils import print

###########################################################
# Global Agentic (GALA) Strategy
###########################################################
def run_gala_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the gala strategy (workers -> assembler)"""
    try:
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        hints = ""

        prompt_dir = utils._resolve_path("prompts/global_constraint_prompts")
        for prompt in prompt_dir.glob("*.txt"):
            ind_prompt = utils.load_file(str(prompt))
            ind_prompt = ind_prompt + f"""
                **Problem description**:
                {problem_data['description']}

                **Input data**:
                {effective_input_data}
                """

            code = utils.call_api(client, model, ind_prompt)
            code = utils.extract_global_constraint(ind_prompt) + ": \n" + code + "\n"
            if "FALSE" not in code:
                hints += code

        assembler_prompt = utils.load_file('prompts/assembler_prompt.txt')
        assembler_prompt = assembler_prompt + f"""
                **Problem description**:
                {problem_data['description']}

                **Input data**:
                {effective_input_data}

                **Hints**:
                {hints}
                """

        code = utils.call_api(client, model, assembler_prompt)

        if not code:
            return False

        utils.save_solution(output_dir, problem_identifier, code)
        return True

    except Exception as e:
        print(f"Error in gala strategy for problem {problem_identifier}: {e}")
        return False
