import argparse
import json
import os
import time

import openai
from datasets import load_dataset
from tqdm import tqdm

import utils


###########################################################
# Single-call Strategy
###########################################################
def run_baseline_strategy(client, problem, problem_identifier, output_dir):
    """Run the baseline single-prompt strategy"""
    try:
        prompt = utils.create_baseline_prompt(problem)
        solution = utils.call_openai_api(client, prompt)

        if solution:
            utils.save_solution(output_dir, problem_identifier, solution)
            return True
        return False
    except Exception as e:
        print(f"Error in baseline strategy for problem {problem_identifier}: {e}")
        return False


###########################################################
# Two-call Strategies
###########################################################
def run_knowledge_graph_strategy(client, problem, problem_identifier, output_dir):
    """Run the strategy using knowledge graphs"""
    try:
        # Check if knowledge graph exists
        kg_path = f"knowledge_graphs/{problem_identifier}.ttl"
        if not os.path.exists(kg_path):
            print(f"Knowledge graph not found for problem {problem_identifier}")
            return False

        problem_data = utils.prepare_problem_data(problem)
        knowledge_graph = utils.load_file(kg_path)

        # Create KG-enhanced prompt
        kg_prompt = utils.load_file('prompts/kg_code_generation_prompt.txt')
        prompt = kg_prompt.format(
            problem_description=problem_data['description'],
            knowledge_graph=knowledge_graph,
            data_nomenclature=problem_data['data_nomenclature']
        )

        solution = utils.call_openai_api(client, prompt)

        if solution:
            utils.save_solution(output_dir, problem_identifier, solution)
            return True
        return False

    except Exception as e:
        print(f"Error in knowledge graph strategy for problem {problem_identifier}: {e}")
        return False


def run_cot_with_code_validation_strategy(client, problem, problem_identifier, output_dir):
    """Run the cot strategy with additional code validation"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)

        # Stage 1: Generate initial code with chain of thought
        cot_prompt = utils.load_file('prompts/cot_prompt.txt')
        initial_code = utils.call_openai_api(
            client,
            cot_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature']
            )
        )

        if not initial_code:
            return False

        time.sleep(2)

        # Stage 2: Validate and refine
        validation_prompt = utils.load_file('prompts/code_validation_prompt.txt')
        validated_code = utils.call_openai_api(
            client,
            validation_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature'],
                objective_type=problem_data['objective_type'],
                final_code=initial_code
            )
        )

        if validated_code:
            utils.save_solution(output_dir, problem_identifier, validated_code)
            return True
        return False

    except Exception as e:
        print(f"Error in two-stage strategy for problem {problem_identifier}: {e}")
        return False


def run_cot_strategy(client, problem, problem_identifier, output_dir):
    """Run the Chain of Thought strategy (single-stage)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)

        # Generate code with chain of thought
        cot_prompt = utils.load_file('prompts/cot_prompt.txt')
        code = utils.call_openai_api(
            client,
            cot_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature']
            )
        )

        if not code:
            return False

        # Save the code
        utils.save_solution(output_dir, problem_identifier, code)
        return True

    except Exception as e:
        print(f"Error in CoT strategy for problem {problem_identifier}: {e}")
        return False


def run_cot_with_grammar_validation_strategy(client, problem, problem_identifier, output_dir):
    """Run the CoT + Grammar Validation strategy (2-stage)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)

        # Stage 1: Generate initial code with chain of thought
        cot_prompt = utils.load_file('prompts/cot_prompt.txt')
        initial_code = utils.call_openai_api(
            client,
            cot_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature']
            )
        )

        if not initial_code:
            return False

        time.sleep(2)

        current_code = initial_code

        # Check syntax of initial code
        syntax_error_message = utils.check_syntax(initial_code, problem['data.dzn'])

        # Stage 2: Grammar-based correction if syntax error exists
        if syntax_error_message:
            grammar_prompt = utils.load_file('prompts/grammar_validation_prompt.txt')
            minizinc_grammar = utils.load_file('grammar.mzn')

            grammar_corrected_code = utils.call_openai_api(
                client,
                grammar_prompt.format(
                    problem_description=problem_data['description'],
                    data_nomenclature=problem_data['data_nomenclature'],
                    current_code=current_code,
                    syntax_error_message=syntax_error_message,
                    minizinc_grammar=minizinc_grammar
                )
            )

            if grammar_corrected_code:
                current_code = grammar_corrected_code

        # Save the final code
        utils.save_solution(output_dir, problem_identifier, current_code)
        return True

    except Exception as e:
        print(f"Error in CoT + Grammar Check strategy for problem {problem_identifier}: {e}")
        return False


###########################################################
# Three-call Strategies
###########################################################
def run_cot_with_code_and_grammar_validation_strategy(client, problem, problem_identifier, output_dir):
    """Run the CoT + Code Validation + Grammar Validation strategy (3-stage)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)

        # Stage 1: Generate initial code with chain of thought
        cot_prompt = utils.load_file('prompts/cot_prompt.txt')
        initial_code = utils.call_openai_api(
            client,
            cot_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature']
            )
        )

        if not initial_code:
            return False

        time.sleep(2)

        current_code = initial_code

        # Check syntax of initial code
        syntax_error_message = utils.check_syntax(initial_code, problem['data.dzn'])

        # Stage 2: Validation if syntax error exists
        if syntax_error_message:
            validation_prompt = utils.load_file('prompts/code_validation_prompt.txt')
            validated_code = utils.call_openai_api(
                client,
                validation_prompt.format(
                    problem_description=problem_data['description'],
                    data_nomenclature=problem_data['data_nomenclature'],
                    objective_type=problem_data['objective_type'],
                    final_code=initial_code,
                    syntax_error_message=syntax_error_message
                )
            )

            if validated_code:
                current_code = validated_code
                # Check syntax again after validation
                syntax_error_message = utils.check_syntax(validated_code, problem['data.dzn'])

            time.sleep(2)

        # Stage 3: Grammar-based correction if syntax error still exists
        if syntax_error_message:
            grammar_prompt = utils.load_file('prompts/grammar_validation_prompt.txt')
            minizinc_grammar = utils.load_file('grammar.mzn')

            grammar_corrected_code = utils.call_openai_api(
                client,
                grammar_prompt.format(
                    problem_description=problem_data['description'],
                    data_nomenclature=problem_data['data_nomenclature'],
                    current_code=current_code,
                    syntax_error_message=syntax_error_message,
                    minizinc_grammar=minizinc_grammar
                )
            )

            if grammar_corrected_code:
                current_code = grammar_corrected_code

        # Save the final code
        utils.save_solution(output_dir, problem_identifier, current_code)
        return True

    except Exception as e:
        print(f"Error in CoT + Validation + Grammar Check strategy for problem {problem_identifier}: {e}")
        return False


###########################################################
# Four and Five-call Strategies
###########################################################
def run_compositional_strategy(client, problem, problem_identifier, output_dir, validate=True):
    """Run the compositional stitch strategy"""
    try:
        problem_data = utils.prepare_problem_data(problem)

        # Step 1: Generate parameters and variables
        param_prompt = utils.load_file('prompts/parameter_and_variable_generation_prompt.txt')
        params_vars = utils.call_openai_api(
            client,
            param_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature']
            )
        )
        if not params_vars:
            return False
        time.sleep(2)

        # Step 2: Generate constraints
        constraint_prompt = utils.load_file('prompts/constraint_generation_prompt.txt')
        constraints = utils.call_openai_api(
            client,
            constraint_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature'],
                parameters_and_variables=params_vars
            )
        )
        if not constraints:
            return False
        time.sleep(2)

        # Step 3: Generate objective
        objective_prompt = utils.load_file('prompts/objective_generation_prompt.txt')
        objective = utils.call_openai_api(
            client,
            objective_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature'],
                parameters_and_variables=params_vars,
                constraints=constraints
            )
        )
        if not objective:
            return False
        time.sleep(2)

        # Step 4: Generate final code
        code_prompt = utils.load_file('prompts/code_stitching_prompt.txt')
        final_code = utils.call_openai_api(
            client,
            code_prompt.format(
                problem_description=problem_data['description'],
                data_nomenclature=problem_data['data_nomenclature'],
                parameters_and_variables=params_vars,
                constraints=constraints,
                objective=objective
            )
        )
        if not final_code:
            return False

        if validate:
            time.sleep(2)
            # Step 5: Validate
            validation_prompt = utils.load_file('prompts/code_validation_prompt.txt')
            validated_code = utils.call_openai_api(
                client,
                validation_prompt.format(
                    problem_description=problem_data['description'],
                    data_nomenclature=problem_data['data_nomenclature'],
                    objective_type=problem_data['objective_type'],
                    final_code=final_code
                )
            )

            if validated_code:
                utils.save_solution(output_dir, problem_identifier, validated_code)
                return True
            return False
        else:
            # Save without validation
            utils.save_solution(output_dir, problem_identifier, final_code)
            return True

    except Exception as e:
        print(f"Error in stitch strategy for problem {problem_identifier}: {e}")
        return False


def main():
    parser = argparse.ArgumentParser(description='Generate MiniZinc code using different prompting strategies')
    parser.add_argument('--model', default='gpt-4', choices=['gpt-4', 'gpt-4o'],
                        help='OpenAI model to use')
    parser.add_argument('--strategies', nargs='+',
                        default=['baseline'],
                        choices=['baseline', 'cot', 'knowledge_graph', 'cot_with_code_validation', 'cot_with_grammar_validation',
                                 'cot_with_code_and_grammar_validation', 'compositional', 'compositional_with_code_validation', 'all'],
                        help='Strategies to run')
    parser.add_argument('--problem-ids', nargs='+', type=int,
                        help='Specific problem IDs to process')
    parser.add_argument('--output-dir', default='output',
                        help='Base output directory')
    parser.add_argument('--api-key', default=os.getenv('OPENAI_API_KEY'),
                        help='OpenAI API key')
    parser.add_argument('--temperature', type=float, default=0,
                        help='Temperature for API calls')
    parser.add_argument('--max-tokens', type=int, default=4096,
                        help='Max tokens for API calls')
    parser.add_argument('--sleep-time', type=float, default=3,
                        help='Sleep time between API calls')

    args = parser.parse_args()

    if not args.api_key:
        raise ValueError("OpenAI API key not provided. Set OPENAI_API_KEY environment variable or use --api-key")

    # Initialize OpenAI client
    client = openai.OpenAI(api_key=args.api_key)

    # Set global API parameters
    utils.API_CONFIG['temperature'] = args.temperature
    utils.API_CONFIG['max_tokens'] = args.max_tokens
    utils.API_CONFIG['sleep_time'] = args.sleep_time
    utils.API_CONFIG['model'] = args.model

    # Load dataset
    print("Loading dataset...")
    dataset = load_dataset("skadio/text2zinc")
    print(f"Loaded dataset with {len(dataset['train'])} examples")

    # Determine which strategies to run
    if 'all' in args.strategies:
        strategies = ['baseline', 'cot', 'knowledge_graph', 'cot_with_code_validation', 'cot_with_grammar_validation',
                      'cot_with_code_and_grammar_validation', 'compositional', 'compositional_with_code_validation']
    else:
        strategies = args.strategies

    # Determine which problems to process
    if args.problem_ids:
        problems_to_process = [(idx, dataset['train'][idx])
                               for idx in args.problem_ids
                               if idx < len(dataset['train'])]
    else:
        problems_to_process = list(enumerate(dataset['train']))

    # Strategy mapping
    strategy_functions = {

        # Single GPT call
        'baseline': run_baseline_strategy,
        'cot': run_cot_strategy,

        # Two GPT calls
        'knowledge_graph': run_knowledge_graph_strategy,

        'cot_with_code_validation': run_cot_with_code_validation_strategy,
        'cot_with_grammar_validation': run_cot_with_grammar_validation_strategy,

        # Three GPT calls
        'cot_with_code_and_grammar_validation': run_cot_with_code_and_grammar_validation_strategy,

        # Four GPT calls
        'compositional': lambda c, p, i, o: run_compositional_strategy(c, p, i, o, validate=False),

        # Five GPT calls
        'compositional_with_code_validation': run_compositional_strategy
    }

    # Process problems
    results = {}
    for strategy in strategies:
        print(f"\nRunning {strategy} strategy with {args.model}...")
        output_dir = os.path.join(args.output_dir, args.model, strategy)
        os.makedirs(output_dir, exist_ok=True)

        results[strategy] = {'success': 0, 'failed': 0}

        for idx, problem in tqdm(problems_to_process, desc=f"{strategy} progress"):
            problem_identifier = ast.literal_eval(problem['input.json'])['metadata']['identifier']
            success = strategy_functions[strategy](client, problem, problem_identifier, output_dir)

            if success:
                results[strategy]['success'] += 1
            else:
                results[strategy]['failed'] += 1

            time.sleep(args.sleep_time)

    # Print summary
    print("\n=== Summary ===")
    for strategy, result in results.items():
        print(f"{strategy}: {result['success']} successful, {result['failed']} failed")

    # Save results summary
    summary_path = os.path.join(args.output_dir, args.model, 'summary.json')
    with open(summary_path, 'w') as f:
        json.dump(results, f, indent=2)
    print(f"\nResults saved to {summary_path}")


if __name__ == "__main__":
    main()
