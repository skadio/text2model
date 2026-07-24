from text2model import utils
from text2model.utils import print

###########################################################
# Two-call Strategy
###########################################################
def run_knowledge_graph_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the strategy using knowledge graphs.

    Uses the bundled, manually-verified .ttl for the 110 curated problems when
    available; otherwise generates one on the fly via an extra LLM call, so
    this works uniformly in both Text2Zinc mode and text mode (--problem).
    """
    try:
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        knowledge_graph = utils.get_knowledge_graph(
            client, model, problem_identifier, problem_data, effective_input_data
        )
        if not knowledge_graph:
            print(f"Could not obtain a knowledge graph for problem {problem_identifier}")
            return False

        kg_prompt = utils.load_file('prompts/kg_code_generation_prompt.txt')
        prompt = kg_prompt.format(
            problem_description=problem_data['description'],
            knowledge_graph=knowledge_graph,
            input_data=effective_input_data
        )

        solution = utils.call_api(client, model, prompt)

        if solution:
            utils.save_solution(output_dir, problem_identifier, solution)
            return True
        return False

    except Exception as e:
        print(f"Error in knowledge graph strategy for problem {problem_identifier}: {e}")
        return False
