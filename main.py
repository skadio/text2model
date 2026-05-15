import argparse
import ast
import json
import os
import time
from pathlib import Path

import openai
from datasets import DatasetDict, load_dataset
from langchain_ollama import ChatOllama
from tqdm import tqdm

import utils


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


###########################################################
# Two-call Strategies
###########################################################
def run_knowledge_graph_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the strategy using knowledge graphs"""
    try:
        # Check if knowledge graph exists
        kg_path = f"knowledge_graphs/{problem_identifier}.ttl"
        if not os.path.exists(kg_path):
            print(f"Knowledge graph not found for problem {problem_identifier}")
            return False

        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)
        knowledge_graph = utils.load_file(kg_path)

        # Create KG-enhanced prompt
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


def run_cot_with_code_validation_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the cot strategy with conditional code validation (only if compilation fails)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        # Stage 1: Generate initial code with chain of thought
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

        # Check if the code compiles (handle empty dzn)
        dzn_data = problem.get('data.dzn') or ""
        syntax_error_message = utils.check_syntax(initial_code, dzn_data)

        # Stage 2: Validate and refine ONLY if there's a compilation error
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


def run_cot_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the Chain of Thought strategy (single-stage)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        # Generate code with chain of thought
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

        # Save the code
        utils.save_solution(output_dir, problem_identifier, code)
        return True

    except Exception as e:
        print(f"Error in CoT strategy for problem {problem_identifier}: {e}")
        return False


def run_cot_with_grammar_validation_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the CoT + Grammar Validation strategy (2-stage)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        # Stage 1: Generate initial code with chain of thought
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

        # Check syntax of initial code
        syntax_error_message = utils.check_syntax(initial_code, problem['data.dzn'])

        # Stage 2: Grammar-based correction if syntax error exists
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

        # Save the final code
        utils.save_solution(output_dir, problem_identifier, current_code)
        return True

    except Exception as e:
        print(f"Error in CoT + Grammar Check strategy for problem {problem_identifier}: {e}")
        return False


###########################################################
# Three-call Strategies
###########################################################
def run_cot_with_code_and_grammar_validation_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the CoT + Code Validation + Grammar Validation strategy (3-stage)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        # Stage 1: Generate initial code with chain of thought
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

        # Check if the code compiles (handle empty dzn)
        dzn_data = problem.get('data.dzn') or ""
        syntax_error_message = utils.check_syntax(initial_code, dzn_data)

        # Stage 2: Validation if syntax error exists
        if syntax_error_message:
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
                # Check syntax again after validation
                syntax_error_message = utils.check_syntax(validated_code, problem['data.dzn'])

            time.sleep(2)

        # Stage 3: Grammar-based correction if syntax error still exists
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

        # Save the final code
        utils.save_solution(output_dir, problem_identifier, current_code)
        return True

    except Exception as e:
        print(f"Error in CoT + Validation + Grammar Check strategy for problem {problem_identifier}: {e}")
        return False


###########################################################
# Four and Five-call Strategies
###########################################################
def run_agents_strategy(client, model, problem, problem_identifier, output_dir, validate=True):
    """Run the agents strategy"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        # Step 1: Generate parameters and variables
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

        # Step 2: Generate constraints
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

        # Step 3: Generate objective
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

        # Step 4: Generate final code
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

        # Check if the code compiles (handle empty dzn)
        dzn_data = problem.get('data.dzn') or ""
        syntax_error_message = utils.check_syntax(final_code, dzn_data)

        if syntax_error_message and validate:
            time.sleep(2)
            # Step 5: Validate
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
            # Save without validation
            utils.save_solution(output_dir, problem_identifier, final_code)
            return True

    except Exception as e:
        print(f"Error in agents strategy for problem {problem_identifier}: {e}")
        return False


###########################################################
# Global Agentic (GALA) Strategies
###########################################################
def run_gala_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the gala strategy (workers -> assembler)"""
    try:
        # Prepare data
        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)

        # Store the code snippets from individual agents
        hints = ""

        prompt_dir = Path("prompts/global_constraint_prompts")
        # Read all the prompts from the global_constraint prompts folder
        for prompt in prompt_dir.glob("*.txt"):
            ind_prompt = utils.load_file(str(prompt))
            ind_prompt = ind_prompt + f"""
                **Problem description**:
                {problem_data['description']}

                **Input data**:
                {effective_input_data}
                """

            code = utils.call_api(client, model, ind_prompt)
            # Add the global constraint type to the output
            code = utils.extract_global_constraint(ind_prompt) + ": \n" + code + "\n"
            # If there is global constraint detected, add it to hints
            if "FALSE" not in code:
                hints += code

        # Assembler to join the code together and make modifications
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

        # Save the code
        utils.save_solution(output_dir, problem_identifier, code)
        return True

    except Exception as e:
        print(f"Error in gala strategy for problem {problem_identifier}: {e}")
        return False


def check_already_processed(output_dir, problem_identifier):
    """Check if a problem has already been successfully processed"""
    solution_path = os.path.join(output_dir, f"{problem_identifier}.mzn")
    return os.path.exists(solution_path) and os.path.getsize(solution_path) > 0


def main():
    parser = argparse.ArgumentParser(description='Generate MiniZinc code using different prompting strategies')
    parser.add_argument('--model', default='gpt-4', choices=['gpt-4', 'gpt-4o', 'gpt-5.2', 'phi4'],
                        help='LLM model to use')
    parser.add_argument('--strategies', nargs='+',
                        default=['baseline'],
                        choices=['baseline', 'cot', 'knowledge_graph', 'cot_with_code_validation', 'cot_with_grammar_validation',
                                 'cot_with_code_and_grammar_validation', 'agents', 'agents_with_code_validation', 'gala', 'all'],
                        help='Strategies to run')
    parser.add_argument('--problem-ids', nargs='+', type=int,
                        help='Specific problem IDs to process')
    parser.add_argument('--source', type=str, nargs='*', default=None,
                        help='Filter problems by source (from metadata). Supports partial matching. Can specify multiple sources.')
    parser.add_argument('--list-sources', action='store_true',
                        help='List all available sources in the dataset and exit')
    parser.add_argument('--include-unverified', action='store_true',
                        help='Include unverified problems (by default only verified problems are used)')
    parser.add_argument('--all-sources', action='store_true',
                        help='Run on all sources')
    parser.add_argument('--output-dir', default='output',
                        help='Base output directory')
    parser.add_argument('--force', action='store_true',
                        help='Re-run and overwrite problems that already have output (default: skip them)')
    parser.add_argument('--api-key', default=os.getenv('OPENAI_API_KEY'),
                        help='OpenAI API key')
    parser.add_argument('--temperature', type=float, default=0,
                        help='Temperature for API calls')
    parser.add_argument('--max-tokens', type=int, default=4096,
                        help='Max tokens for API calls')
    parser.add_argument('--sleep-time', type=float, default=3,
                        help='Sleep time between API calls')

    args = parser.parse_args()

    # Load dataset
    print("Loading dataset...")
    dataset = load_dataset("skadio/text2zinc")

    # Filter by verified status (default: only verified, unless --include-unverified is set)
    if args.include_unverified:
        print(f"Including ALL problems (verified and unverified)")
        filtered_train = dataset["train"]
    else:
        print(f"Including only VERIFIED problems (use --include-unverified to include all)")
        filtered_train = dataset["train"].filter(lambda x: x["is_verified"])
    
    dataset = DatasetDict({
        "train": filtered_train
    })
    print(f"Loaded dataset with {len(dataset['train'])} examples")

    # List sources if requested
    if args.list_sources:
        print("\nAvailable sources in the dataset:")
        sources = utils.get_available_sources(dataset['train'])
        for source in sources:
            # Count instances per source
            count = sum(1 for p in dataset['train'] if utils.get_problem_source(p) == source)
            print(f"  - {source}: {count} instances")
        return

    # Filter by source if specified
    if args.source:
        print(f"\nFiltering dataset by sources: {args.source}")
        # Combine filters for multiple sources
        def matches_any_source(problem):
            source = utils.get_problem_source(problem)
            if source is None:
                return False
            return any(s.lower() in source.lower() for s in args.source)
        
        filtered_train = dataset['train'].filter(matches_any_source)
        dataset = DatasetDict({
            "train": filtered_train
        })
        print(f"Filtered dataset contains {len(dataset['train'])} instances matching sources")
        
        if len(dataset['train']) == 0:
            print("\nNo instances found matching the specified source.")
            print("Use --list-sources to see available sources.")
            return

    if args.model in ["gpt-4", "gpt-4o", "gpt-5.2"]:
        if not args.api_key:
            raise ValueError("OpenAI API key not provided. Set OPENAI_API_KEY environment variable or use --api-key")

        # Initialize OpenAI client
        client = openai.OpenAI(api_key=args.api_key)

        # Set global API parameters
        utils.API_CONFIG['temperature'] = args.temperature
        utils.API_CONFIG['max_tokens'] = args.max_tokens
        utils.API_CONFIG['sleep_time'] = args.sleep_time
        utils.API_CONFIG['model'] = args.model
    else:
        # Initialize Ollama client
        client = ChatOllama(
                model=args.model,
                temperature=args.temperature,
                num_predict=args.max_tokens)

    # Determine which strategies to run
    if 'all' in args.strategies:
        strategies = ['baseline', 'cot', 'knowledge_graph', 'cot_with_code_validation', 'cot_with_grammar_validation',
                      'cot_with_code_and_grammar_validation', 'agents', 'agents_with_code_validation', 'gala']
    else:
        strategies = args.strategies

    # Determine which problems to process
    if args.problem_ids:
        problems_to_process = [(idx, dataset['train'][idx])
                               for idx in args.problem_ids
                               if idx < len(dataset['train'])]
    else:
        problems_to_process = list(enumerate(dataset['train']))

    # Print summary before running
    print(f"\n{'='*50}")
    print(f"RUN CONFIGURATION SUMMARY")
    print(f"{'='*50}")
    print(f"Model: {args.model}")
    print(f"Strategies: {', '.join(strategies)}")
    print(f"Source filter: {args.source if args.source else 'None (all sources)'}")
    print(f"Include unverified: {args.include_unverified}")
    print(f"Number of instances to process: {len(problems_to_process)}")
    print(f"Output directory: {args.output_dir}")
    print(f"{'='*50}\n")

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
        'agents': lambda c, m, p, i, o: run_agents_strategy(c, m, p, i, o, validate=False),

        # Five GPT calls
        'agents_with_code_validation': run_agents_strategy,

        # Global Agentic Strategy
        'gala': run_gala_strategy
    }

    # Process problems
    results = {}
    for strategy in strategies:
        print(f"\nRunning {strategy} strategy with {args.model}...")
        
        results[strategy] = {'success': 0, 'failed': 0, 'errors': []}

        for idx, problem in tqdm(problems_to_process, desc=f"{strategy} progress"):
            try:
                problem_identifier = utils.get_problem_identifier(problem, idx)
                
                # Determine output directory based on source
                cardinal_subfolder = utils.get_cardinal_ops_subfolder(problem)
                if cardinal_subfolder:
                    # For cardinal_operations datasets: strategy_subfolder structure
                    output_dir = os.path.join(args.output_dir, args.model, f"{strategy}_{cardinal_subfolder}")
                else:
                    # For other datasets: keep original structure
                    output_dir = os.path.join(args.output_dir, args.model, strategy)
                
                if not args.force and check_already_processed(output_dir, problem_identifier):
                    continue
                
                os.makedirs(output_dir, exist_ok=True)
                
                success = strategy_functions[strategy](client, args.model, problem, problem_identifier, output_dir)

                if success:
                    results[strategy]['success'] += 1
                else:
                    results[strategy]['failed'] += 1
                    results[strategy]['errors'].append({
                        'idx': idx,
                        'identifier': problem_identifier,
                        'error': 'Strategy returned False'
                    })

            except Exception as e:
                # Catch any unexpected errors to prevent breaking the loop
                print(f"\nUnexpected error processing problem at index {idx}: {e}")
                results[strategy]['failed'] += 1
                problem_identifier = utils.get_problem_identifier(problem, idx)
                results[strategy]['errors'].append({
                    'idx': idx,
                    'identifier': problem_identifier,
                    'error': str(e)
                })
                # Continue to next problem instead of breaking
                continue

            time.sleep(args.sleep_time)

    # Print summary
    print("\n" + "="*50)
    print("SUMMARY")
    print("="*50)
    for strategy, result in results.items():
        total = result['success'] + result['failed']
        success_rate = (result['success'] / total * 100) if total > 0 else 0
        print(f"{strategy}: {result['success']}/{total} successful ({success_rate:.1f}%)")
        if result['errors']:
            print(f"  Failed instances:")
            for err in result['errors'][:5]:  # Show first 5 errors
                print(f"    - {err['identifier']}: {err['error'][:50]}...")
            if len(result['errors']) > 5:
                print(f"    ... and {len(result['errors']) - 5} more errors")

    # Prepare results for JSON (remove detailed errors for cleaner output)
    results_for_json = {
        strategy: {
            'success': result['success'],
            'failed': result['failed'],
            'total': result['success'] + result['failed'],
            'success_rate': (result['success'] / (result['success'] + result['failed']) * 100) 
                           if (result['success'] + result['failed']) > 0 else 0,
            'failed_identifiers': [err['identifier'] for err in result['errors']]
        }
        for strategy, result in results.items()
    }

    # Add metadata to results
    results_for_json['_metadata'] = {
        'model': args.model,
        'source_filter': args.source,
        'include_unverified': args.include_unverified,
        'num_instances': len(problems_to_process),
        'strategies': strategies
    }

    # Save results summary
    summary_path = os.path.join(args.output_dir, args.model, 'summary.json')
    os.makedirs(os.path.dirname(summary_path), exist_ok=True)
    with open(summary_path, 'w') as f:
        json.dump(results_for_json, f, indent=2)
    print(f"\nResults saved to {summary_path}")


if __name__ == "__main__":
    main()
