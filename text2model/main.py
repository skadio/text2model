import argparse
import ast
import json
import os
import sys
import tempfile
import time
from pathlib import Path

import openai
from langchain_ollama import ChatOllama
from tqdm import tqdm

from text2model import copilots, huggingface, utils
from text2model.utils import print

# NOTE: `datasets` (HuggingFace) is intentionally imported lazily, inside
# utils.load_text2zinc_dataset() rather than at module scope. Text mode
# (--problem) never calls that function, so importing it eagerly here
# would mean every text2model invocation pays for/depends on the HF stack
# even when it's never used.

# Models available via --model. OpenAI models require OPENAI_API_KEY; Ollama
# models are served by a local daemon, no API key needed; Hugging Face models
# are loaded directly into this process via unsloth (no daemon, no API key,
# but needs a GPU and the first call pays a one-time model-load cost). These
# are not finetuned to follow every copilot strategy's prompt shape equally
# well — start with `baseline`/`cot` and treat the rest as best-effort.
AVAILABLE_MODELS = {
    'gpt-4': 'OpenAI, requires OPENAI_API_KEY',
    'gpt-4o': 'OpenAI, requires OPENAI_API_KEY',
    'gpt-5.2': 'OpenAI, requires OPENAI_API_KEY',
    'gpt-5.5': 'OpenAI, requires OPENAI_API_KEY',
    'gpt-5.6': 'OpenAI, requires OPENAI_API_KEY',
    'phi4': 'Local, served through Ollama, no API key needed',
    **{
        alias: f"Local, Hugging Face model ({config['repo_id']}) loaded in-process via unsloth, no API key needed"
        for alias, config in huggingface.HUGGINGFACE_MODELS.items()
    },
}

AVAILABLE_STRATEGIES = [
    'baseline', 'cot', 'knowledge_graph',
    'cot_with_code', 'cot_with_grammar',
    'cot_with_code_and_grammar',
    'agents', 'agents_with_code', 'gala', 'all',
]


###########################################################
# Helpers
###########################################################
def check_already_processed(output_dir, problem_identifier):
    """Check if a problem has already been successfully processed"""
    solution_path = os.path.join(output_dir, f"{problem_identifier}.mzn")
    return os.path.exists(solution_path) and os.path.getsize(solution_path) > 0


# Strategy implementations live under text2model/copilots/ (one module per
# strategy); this is just the name -> function registry used to dispatch.
_STRATEGY_MAP = copilots.STRATEGY_MAP


def _init_client(args):
    """Create and configure the LLM client from parsed args."""
    if args.model in utils.OPENAI_MODELS:
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
        utils.API_CONFIG['reasoning_effort'] = args.reasoning_effort
        if args.reasoning_effort and args.model not in utils.REASONING_EFFORT_MODELS:
            print(
                f"Warning: --reasoning-effort is ignored for model '{args.model}' "
                f"(only supported for {sorted(utils.REASONING_EFFORT_MODELS)})."
            )
    elif args.model in huggingface.HUGGINGFACE_MODELS:
        client = huggingface.load_huggingface_model(args.model)
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

    # Use the first requested strategy; default to 'cot_with_grammar'
    strategy = (args.strategies or ['cot_with_grammar'])[0]

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
            '  2) Text2Zinc mode (--problem-ids): give Text2Zinc problem indices or identifiers\n'
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
            '  # List problem indices/identifiers available to pass to --problem-ids\n'
            '  text2model --list-problem-ids --source "csplib"\n\n'
            '  # Text2Zinc mode: run the chain-of-thought strategy over one source\n'
            '  text2model --strategies cot --source "csplib" --output-dir results/\n\n'
            '  # Text2Zinc mode: run specific problems by index and/or identifier\n'
            '  text2model --strategies cot --problem-ids 0 nlp4lp_58 --output-dir results/\n\n'
            '  # Text2Zinc mode against a locally-edited dataset instead of HuggingFace\n'
            '  text2model --strategies cot --text2zinc-path text2zinc_edited.csv --output-dir results/\n\n'
            '  # Launch the dataset editor to create/edit a local Text2Zinc dataset\n'
            '  text2model --editor\n\n'
            'The OpenAI API key can also be set via the OPENAI_API_KEY environment '
            'variable. Local models (e.g. phi4) are served through Ollama and need '
            'no API key.'
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

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
             "--text2zinc-path to open a specific local CSV instead of pulling "
             "fresh from the HuggingFace dataset."
    )

    # ── Model / API ─────────────────────────────────────────────────────────
    parser.add_argument('--model', default='gpt-5.2',
                        choices=list(AVAILABLE_MODELS.keys()),
                        help='LLM model to use')
    parser.add_argument('--api-key', default=os.getenv('OPENAI_API_KEY'),
                        help='OpenAI API key')
    parser.add_argument('--temperature', type=float, default=0,
                        help='Temperature for API calls. Ignored for reasoning models '
                             f'({sorted(utils.REASONING_MODELS)}).')
    parser.add_argument('--max-tokens', type=int, default=4096,
                        help='Max tokens for API calls. Ignored for reasoning models '
                             f'({sorted(utils.REASONING_MODELS)}).')
    parser.add_argument('--sleep-time', type=float, default=3,
                        help='Sleep time between API calls')
    parser.add_argument('--reasoning-effort', default=None,
                        choices=['none', 'low', 'medium', 'high', 'xhigh', 'max'],
                        help='Reasoning-effort hint, only used for gpt-5.5 / gpt-5.6 '
                             '("max" is gpt-5.6 only). Ignored by other models.')

    # ── Strategy ────────────────────────────────────────────────────────────
    parser.add_argument(
        '--strategies', nargs='+',
        default=['cot_with_grammar'],
        choices=AVAILABLE_STRATEGIES,
        help='Strategy (or strategies for Text2Zinc mode). '
             'In --problem mode only the first strategy is used; default is cot_with_grammar.'
    )

    # ── Text2Zinc-mode dataset arguments ────────────────────────────────────
    parser.add_argument('--problem-ids', nargs='+', type=str,
                        help='Specific problems to process (Text2Zinc mode). Each value is either '
                             'a dataset index (e.g. 0) or a problem identifier (e.g. nlp4lp_58, '
                             'matching the "identifier" dataset metadata field and output/.ttl '
                             'filenames). Resolved against the dataset after --full-dataset/--source '
                             'filtering; use --list-problem-ids to see what is available.')
    parser.add_argument('--source', type=str, nargs='*', default=None,
                        help='Filter problems by source (Text2Zinc mode). Supports partial matching.')
    parser.add_argument('--list-sources', action='store_true',
                        help='List all available sources in the dataset and exit')
    parser.add_argument('--list-problem-ids', action='store_true',
                        help='List the index, identifier, and source of each problem in the '
                             '(optionally --source/--full-dataset filtered) dataset, then exit. '
                             'Use these indices/identifiers with --problem-ids.')
    parser.add_argument('--list-models', action='store_true',
                        help='List all available --model options and exit')
    parser.add_argument('--list-strategies', action='store_true',
                        help='List all available strategy options and exit')
    parser.add_argument('--full-dataset', action='store_true',
                        help='Run on the full dataset instead of only the problems with '
                             'manually verified MiniZinc models (Text2Zinc mode)')
    parser.add_argument('--output-dir', default=None,
                        help='Base output directory for Text2Zinc mode (must not already exist)')
    parser.add_argument('--text2zinc-path', default=None,
        help='Path to a local Text2Zinc CSV dataset (e.g. one saved by `text2model --editor`), '
             'used instead of the default skadio/text2zinc HuggingFace dataset (Text2Zinc mode).')
    parser.add_argument('--upgrade-text2zinc', action='store_true',
        help='Force a fresh download of the skadio/text2zinc HuggingFace dataset instead of '
             'reusing the local datasets cache. Ignored when --text2zinc-path is set.')

    if len(sys.argv) == 1:
        print(parser.format_help(), end='')
        return

    args = parser.parse_args()

    # ── --editor: launch the GUI dataset editor, no API key needed ─────────
    if args.editor:
        from text2model.editor import launch as launch_editor
        launch_editor(text2zinc_path=args.text2zinc_path)
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
    if not args.list_sources and not args.list_problem_ids and not args.output_dir:
        parser.error(
            "--output-dir is required in Text2Zinc mode "
            "(not needed with --problem, --list-sources, or --list-problem-ids)"
        )

    if args.text2zinc_path:
        print(f"Loading local dataset from {args.text2zinc_path}...")
    elif args.upgrade_text2zinc:
        print("Loading dataset from HuggingFace (skadio/text2zinc), forcing a fresh download...")
    else:
        print("Loading dataset from HuggingFace (skadio/text2zinc)...")
    dataset_train = utils.load_text2zinc_dataset(
        args.text2zinc_path, force_download=args.upgrade_text2zinc
    )

    # --list-sources is a discovery command: always show sources across the
    # entire dataset, regardless of --full-dataset.
    if args.list_sources:
        print("\nAvailable sources in the dataset:")
        sources = utils.get_available_sources(dataset_train)
        for source in sources:
            count = sum(1 for p in dataset_train if utils.get_problem_source(p) == source)
            print(f"  - {source}: {count} instances")
        return

    if args.full_dataset:
        print("Including the full dataset")
    else:
        print("Including only problems with manually verified MiniZinc models (use --full-dataset to include all)")
        dataset_train = dataset_train.filter(lambda x: x["is_verified"])

    print(f"Loaded dataset with {len(dataset_train)} examples")

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

    # --list-problem-ids reflects --full-dataset/--source filtering (unlike
    # --list-sources, which always covers the whole dataset), since its
    # purpose is to show exactly what --problem-ids can select for this run.
    if args.list_problem_ids:
        print(f"\n{len(dataset_train)} problem(s) available:")
        print(f"{'IDX':>5}  {'IDENTIFIER':<30}  SOURCE")
        for idx, problem in enumerate(dataset_train):
            identifier = utils.get_problem_identifier(problem, idx)
            source = utils.get_problem_source(problem) or "unknown"
            print(f"{idx:>5}  {identifier:<30}  {source}")
        return

    while os.path.exists(args.output_dir):
        print(f"Output directory '{args.output_dir}' already exists. Please choose a different name.")
        new_dir = input("Enter a new output directory name: ").strip()
        if new_dir:
            args.output_dir = new_dir

    client = _init_client(args)

    if 'all' in args.strategies:
        strategies = [
            'baseline', 'cot', 'knowledge_graph',
            'cot_with_code', 'cot_with_grammar',
            'cot_with_code_and_grammar',
            'agents', 'agents_with_code', 'gala',
        ]
    else:
        strategies = args.strategies

    if args.problem_ids:
        problems_to_process = utils.resolve_problem_ids(dataset_train, args.problem_ids)
    else:
        problems_to_process = list(enumerate(dataset_train))

    print(f"\n{'='*50}")
    print("RUN CONFIGURATION SUMMARY")
    print(f"{'='*50}")
    print(f"Model: {args.model}")
    print(f"Dataset: {args.text2zinc_path if args.text2zinc_path else 'skadio/text2zinc (HuggingFace)'}")
    print(f"Strategies: {', '.join(strategies)}")
    print(f"Source filter: {args.source if args.source else 'None (all sources)'}")
    print(f"Full dataset: {args.full_dataset}")
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
        'full_dataset': args.full_dataset,
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
