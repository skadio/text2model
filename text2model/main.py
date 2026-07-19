import argparse
import ast
from builtins import print as builtin_print
import json
import os
import sys
import tempfile
import time
from pathlib import Path

import openai
from langchain_ollama import ChatOllama
from tqdm import tqdm

from text2model import utils

# NOTE: `datasets` (HuggingFace) is intentionally imported lazily, inside the
# Text2Zinc-mode code path in main(), rather than at module scope. Text mode
# (--problem) never touches the HF dataset, so importing it eagerly here
# would mean every text2model invocation pays for/depends on the HF stack
# even when it's never used.

# Models available via --model. OpenAI models require OPENAI_API_KEY; local
# models (served through Ollama) need no API key.
AVAILABLE_MODELS = {
    'gpt-4': 'OpenAI, requires OPENAI_API_KEY',
    'gpt-4o': 'OpenAI, requires OPENAI_API_KEY',
    'gpt-5.2': 'OpenAI, requires OPENAI_API_KEY',
    'phi4': 'Local, served through Ollama, no API key needed',
}

AVAILABLE_STRATEGIES = [
    'baseline', 'cot', 'knowledge_graph',
    'cot_with_code_validation', 'cot_with_grammar_validation',
    'cot_with_code_and_grammar_validation',
    'agents', 'agents_with_code_validation', 'gala', 'all',
]


def print(*args, **kwargs):
    """Print comment-prefixed CLI text so redirected stdout stays MiniZinc-safe."""
    file = kwargs.pop('file', sys.stdout)
    sep = kwargs.pop('sep', ' ')
    end = kwargs.pop('end', '\n')
    flush = kwargs.pop('flush', False)
    text = sep.join(str(arg) for arg in args)
    if text:
        text = '\n'.join(f'% {line}' for line in text.splitlines())
    else:
        text = '% '
    builtin_print(text, file=file, end=end, flush=flush, **kwargs)


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
        kg_path = utils._resolve_path(f"knowledge_graphs/{problem_identifier}.ttl")
        if not kg_path.exists():
            print(f"Knowledge graph not found for problem {problem_identifier}")
            return False

        problem_data = utils.prepare_problem_data(problem)
        effective_input_data = utils.get_effective_input_data(problem_data)
        knowledge_graph = utils.load_file(str(kg_path))

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


def run_cot_with_grammar_validation_strategy(client, model, problem, problem_identifier, output_dir):
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


###########################################################
# Three-call Strategies
###########################################################
def run_cot_with_code_and_grammar_validation_strategy(client, model, problem, problem_identifier, output_dir):
    """Run the CoT + Code Validation + Grammar Validation strategy (3-stage)"""
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
                dzn_data2 = problem.get('data.dzn') or ""
                syntax_error_message = utils.check_syntax(validated_code, dzn_data2)

            time.sleep(2)

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
        print(f"Error in CoT + Validation + Grammar Check strategy for problem {problem_identifier}: {e}")
        return False


###########################################################
# Four and Five-call Strategies
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


###########################################################
# Global Agentic (GALA) Strategies
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


###########################################################
# Helpers
###########################################################
def check_already_processed(output_dir, problem_identifier):
    """Check if a problem has already been successfully processed"""
    solution_path = os.path.join(output_dir, f"{problem_identifier}.mzn")
    return os.path.exists(solution_path) and os.path.getsize(solution_path) > 0


_STRATEGY_MAP = {
    'baseline': run_baseline_strategy,
    'cot': run_cot_strategy,
    'knowledge_graph': run_knowledge_graph_strategy,
    'cot_with_code_validation': run_cot_with_code_validation_strategy,
    'cot_with_grammar_validation': run_cot_with_grammar_validation_strategy,
    'cot_with_code_and_grammar_validation': run_cot_with_code_and_grammar_validation_strategy,
    'agents': lambda c, m, p, i, o: run_agents_strategy(c, m, p, i, o, validate=False),
    'agents_with_code_validation': run_agents_strategy,
    'gala': run_gala_strategy,
}


def _init_client(args):
    """Create and configure the LLM client from parsed args."""
    if args.model in ["gpt-4", "gpt-4o", "gpt-5.2"]:
        if not args.api_key:
            raise ValueError(
                "OpenAI API key not provided. "
                "Set OPENAI_API_KEY environment variable or use --api-key"
            )
        client = openai.OpenAI(api_key=args.api_key)
        utils.API_CONFIG['temperature'] = args.temperature
        utils.API_CONFIG['max_tokens'] = args.max_tokens
        utils.API_CONFIG['sleep_time'] = args.sleep_time
        utils.API_CONFIG['model'] = args.model
    else:
        client = ChatOllama(
            model=args.model,
            temperature=args.temperature,
            num_predict=args.max_tokens,
        )
    return client


def _run_problem_mode(args, client):
    """Handle --problem mode: generate MiniZinc from a single problem description."""
    # Accept a file path or a literal description string
    problem_text = args.problem
    if os.path.isfile(problem_text):
        with open(problem_text, 'r') as f:
            problem_text = f.read()

    problem = utils.create_problem_from_text(problem_text)

    # Use the first requested strategy; default to 'cot'
    strategy = (args.strategies or ['cot'])[0]

    if strategy == 'knowledge_graph':
        print(
            "Warning: 'knowledge_graph' strategy requires pre-built TTL files. "
            "Falling back to 'cot'.",
        )
        strategy = 'cot'

    strategy_fn = _STRATEGY_MAP[strategy]

    print(f"Generating MiniZinc model using strategy '{strategy}' with model '{args.model}'...")

    with tempfile.TemporaryDirectory() as tmpdir:
        success = strategy_fn(client, args.model, problem, 'output', tmpdir)
        if success:
            output_path = os.path.join(tmpdir, 'output.mzn')
            with open(output_path) as f:
                code = f.read()
            sys.stdout.write(code if code.endswith("\n") else code + "\n")
        else:
            print("Failed to generate MiniZinc code.")
            sys.exit(1)


###########################################################
# Entry point
###########################################################
def main():
    parser = argparse.ArgumentParser(
        prog='text2model',
        description=(
            'text2model: translate problem descriptions given in natural language text'
            ' into MiniZinc constraint models using an LLM Modeling Copilot strategy.\n\n'
            'Usage modes:\n'
            '  1) Text mode (--problem): give input text or file\n'
            '  2) Text2Zinc mode (--problem-ids): give Text2Zinc problem ids\n'
            '  3) Editor mode (--editor): launch the dataset editor GUI\n'
        ),
        epilog=(
            'Examples:\n'
            '  # Translate a problem description given directly on the command line\n'
            '  text2model --problem "Pack items of given weights into the fewest bins "\\\n'
            '                        "of capacity 10." --model gpt-4o --api-key sk-...\n\n'
            '  # Translate a problem description stored in a file\n'
            '  text2model --problem problem.txt --model gpt-4o\n\n'
            '  # List the sources available in the benchmark dataset\n'
            '  text2model --list-sources\n\n'
            '  # List the available --model options\n'
            '  text2model --list-models\n\n'
            '  # Text2Zinc mode: run the chain-of-thought strategy over one source\n'
            '  text2model --strategies cot --source "csplib" --output-dir results/\n\n'
            '  # Text2Zinc mode against a locally-edited dataset instead of HuggingFace\n'
            '  text2model --strategies cot --dataset-path text2zinc_edited.csv --output-dir results/\n\n'
            '  # Launch the dataset editor to create/edit a local Text2Zinc dataset\n'
            '  text2model --editor\n\n'
            'The OpenAI API key can also be set via the OPENAI_API_KEY environment '
            'variable. Local models (e.g. phi4) are served through Ollama and need '
            'no API key.'
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    if len(sys.argv) == 1:
        print(parser.format_help(), end='')
        return

    # ── Simple single-problem mode ──────────────────────────────────────────
    parser.add_argument(
        '--problem', type=str, default=None,
        help='Problem description string, or path to a .txt file containing the description. '
             'When provided, generates MiniZinc code and prints it to stdout.'
    )

    # ── Dataset editor ──────────────────────────────────────────────────────
    parser.add_argument(
        '--editor', action='store_true',
        help="Launch the Text2Zinc dataset editor (GUI) and exit. Combine with "
             "--dataset-path to open a specific local CSV instead of the "
             "bundled default dataset."
    )

    # ── Model / API ─────────────────────────────────────────────────────────
    parser.add_argument('--model', default='gpt-4',
                        choices=['gpt-4', 'gpt-4o', 'gpt-5.2', 'phi4'],
                        help='LLM model to use')
    parser.add_argument('--api-key', default=os.getenv('OPENAI_API_KEY'),
                        help='OpenAI API key')
    parser.add_argument('--temperature', type=float, default=0,
                        help='Temperature for API calls')
    parser.add_argument('--max-tokens', type=int, default=4096,
                        help='Max tokens for API calls')
    parser.add_argument('--sleep-time', type=float, default=3,
                        help='Sleep time between API calls')

    # ── Strategy ────────────────────────────────────────────────────────────
    parser.add_argument(
        '--strategies', nargs='+',
        default=['cot'],
        choices=AVAILABLE_STRATEGIES,
        help='Strategy (or strategies for Text2Zinc mode). '
             'In --problem mode only the first strategy is used; default is cot.'
    )

    # ── Text2Zinc-mode dataset arguments ────────────────────────────────────
    parser.add_argument('--problem-ids', nargs='+', type=int,
                        help='Specific problem IDs to process (Text2Zinc mode)')
    parser.add_argument('--source', type=str, nargs='*', default=None,
                        help='Filter problems by source (Text2Zinc mode). Supports partial matching.')
    parser.add_argument('--list-sources', action='store_true',
                        help='List all available sources in the dataset and exit')
    parser.add_argument('--list-models', action='store_true',
                        help='List all available --model options and exit')
    parser.add_argument('--list-strategies', action='store_true',
                        help='List all available strategy options and exit')
    parser.add_argument('--include-unverified', action='store_true',
                        help='Include unverified problems (Text2Zinc mode)')
    parser.add_argument('--all-sources', action='store_true',
                        help='Run on all sources (Text2Zinc mode)')
    parser.add_argument('--output-dir', default=None,
                        help='Base output directory for Text2Zinc mode (must not already exist)')
    parser.add_argument('--dataset-path', default=None,
        help='Path to a local Text2Zinc CSV dataset (e.g. one saved by `text2model --editor`), '
             'used instead of the default skadio/text2zinc HuggingFace dataset (Text2Zinc mode).')

    args = parser.parse_args()

    # ── --editor: launch the GUI dataset editor, no API key needed ─────────
    if args.editor:
        from text2model.editor import launch as launch_editor
        launch_editor(dataset_path=args.dataset_path)
        return

    # ── --list-models: no dataset, no API key needed ────────────────────────
    if args.list_models:
        print("\nAvailable --model options:")
        for model, note in AVAILABLE_MODELS.items():
            print(f"  - {model}: {note}")
        return

    if args.list_strategies:
        print("\nAvailable --strategies options:")
        for strategy in AVAILABLE_STRATEGIES:
            print(f"  - {strategy}")
        return

    # ── --problem mode: skip dataset loading ────────────────────────────────
    if args.problem:
        client = _init_client(args)
        _run_problem_mode(args, client)
        return

    # ── Text2Zinc mode ───────────────────────────────────────────────────────
    # Validate before touching the network: a mistyped/incomplete command
    # (e.g. forgetting --problem or --output-dir) should fail fast instead of
    # first downloading the full HF dataset.
    if not args.list_sources and not args.output_dir:
        parser.error("--output-dir is required in Text2Zinc mode (not needed with --problem or --list-sources)")

    if args.dataset_path:
        print(f"Loading local dataset from {args.dataset_path}...")
    else:
        print("Loading dataset from HuggingFace (skadio/text2zinc)...")
    dataset_train = utils.load_text2zinc_dataset(args.dataset_path)

    if args.include_unverified:
        print("Including ALL problems (verified and unverified)")
    else:
        print("Including only VERIFIED problems (use --include-unverified to include all)")
        dataset_train = dataset_train.filter(lambda x: x["is_verified"])

    print(f"Loaded dataset with {len(dataset_train)} examples")

    if args.list_sources:
        print("\nAvailable sources in the dataset:")
        sources = utils.get_available_sources(dataset_train)
        for source in sources:
            count = sum(1 for p in dataset_train if utils.get_problem_source(p) == source)
            print(f"  - {source}: {count} instances")
        return

    while os.path.exists(args.output_dir):
        print(f"Output directory '{args.output_dir}' already exists. Please choose a different name.")
        new_dir = input("Enter a new output directory name: ").strip()
        if new_dir:
            args.output_dir = new_dir

    if args.source:
        print(f"\nFiltering dataset by sources: {args.source}")

        def matches_any_source(problem):
            source = utils.get_problem_source(problem)
            if source is None:
                return False
            return any(s.lower() in source.lower() for s in args.source)

        dataset_train = dataset_train.filter(matches_any_source)
        print(f"Filtered dataset contains {len(dataset_train)} instances matching sources")

        if len(dataset_train) == 0:
            print("\nNo instances found matching the specified source.")
            print("Use --list-sources to see available sources.")
            return

    client = _init_client(args)

    if 'all' in args.strategies:
        strategies = [
            'baseline', 'cot', 'knowledge_graph',
            'cot_with_code_validation', 'cot_with_grammar_validation',
            'cot_with_code_and_grammar_validation',
            'agents', 'agents_with_code_validation', 'gala',
        ]
    else:
        strategies = args.strategies

    if args.problem_ids:
        problems_to_process = [
            (idx, dataset_train[idx])
            for idx in args.problem_ids
            if idx < len(dataset_train)
        ]
    else:
        problems_to_process = list(enumerate(dataset_train))

    print(f"\n{'='*50}")
    print("RUN CONFIGURATION SUMMARY")
    print(f"{'='*50}")
    print(f"Model: {args.model}")
    print(f"Dataset: {args.dataset_path if args.dataset_path else 'skadio/text2zinc (HuggingFace)'}")
    print(f"Strategies: {', '.join(strategies)}")
    print(f"Source filter: {args.source if args.source else 'None (all sources)'}")
    print(f"Include unverified: {args.include_unverified}")
    print(f"Number of instances to process: {len(problems_to_process)}")
    print(f"Output directory: {args.output_dir}")
    print(f"{'='*50}\n")

    results = {}
    for strategy in strategies:
        print(f"\nRunning {strategy} strategy with {args.model}...")

        results[strategy] = {'success': 0, 'failed': 0, 'errors': []}

        for idx, problem in tqdm(problems_to_process, desc=f"{strategy} progress"):
            try:
                problem_identifier = utils.get_problem_identifier(problem, idx)

                cardinal_subfolder = utils.get_cardinal_ops_subfolder(problem)
                if cardinal_subfolder:
                    output_dir = os.path.join(
                        args.output_dir, args.model, f"{strategy}_{cardinal_subfolder}"
                    )
                else:
                    output_dir = os.path.join(args.output_dir, args.model, strategy)

                if check_already_processed(output_dir, problem_identifier):
                    continue

                os.makedirs(output_dir, exist_ok=True)

                success = _STRATEGY_MAP[strategy](client, args.model, problem, problem_identifier, output_dir)

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
                print(f"\nUnexpected error processing problem at index {idx}: {e}")
                results[strategy]['failed'] += 1
                problem_identifier = utils.get_problem_identifier(problem, idx)
                results[strategy]['errors'].append({
                    'idx': idx,
                    'identifier': problem_identifier,
                    'error': str(e)
                })
                continue

            time.sleep(args.sleep_time)

    print("\n" + "="*50)
    print("SUMMARY")
    print("="*50)
    for strategy, result in results.items():
        total = result['success'] + result['failed']
        success_rate = (result['success'] / total * 100) if total > 0 else 0
        print(f"{strategy}: {result['success']}/{total} successful ({success_rate:.1f}%)")
        if result['errors']:
            print("  Failed instances:")
            for err in result['errors'][:5]:
                print(f"    - {err['identifier']}: {err['error'][:50]}...")
            if len(result['errors']) > 5:
                print(f"    ... and {len(result['errors']) - 5} more errors")

    results_for_json = {
        strategy: {
            'success': result['success'],
            'failed': result['failed'],
            'total': result['success'] + result['failed'],
            'success_rate': (
                result['success'] / (result['success'] + result['failed']) * 100
                if (result['success'] + result['failed']) > 0 else 0
            ),
            'failed_identifiers': [err['identifier'] for err in result['errors']]
        }
        for strategy, result in results.items()
    }

    results_for_json['_metadata'] = {
        'model': args.model,
        'source_filter': args.source,
        'include_unverified': args.include_unverified,
        'num_instances': len(problems_to_process),
        'strategies': strategies,
    }

    summary_path = os.path.join(args.output_dir, args.model, 'summary.json')
    os.makedirs(os.path.dirname(summary_path), exist_ok=True)
    with open(summary_path, 'w') as f:
        json.dump(results_for_json, f, indent=2)
    print(f"\nResults saved to {summary_path}")


if __name__ == "__main__":
    main()
