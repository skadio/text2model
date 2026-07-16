[![Tests](https://github.com/skadio/text2model/actions/workflows/tests.yml/badge.svg)](https://github.com/skadio/text2model/actions/workflows/tests.yml)
[![PyPI version](https://img.shields.io/pypi/v/text2model.svg?cacheSeconds=1)](https://pypi.org/project/text2model/)
[![PyPI license](https://img.shields.io/pypi/l/text2model.svg?cacheSeconds=1)](https://pypi.python.org/pypi/text2model/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Downloads](https://static.pepy.tech/personalized-badge/text2model?period=total&units=international_system&left_color=grey&right_color=orange&left_text=Downloads)](https://pepy.tech/project/text2model)

---

<div align="center"><a name="menu"></a>
  <h3>
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#text-mode">Text Mode</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#text2zinc-mode">Text2Zinc Mode</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#copilots">Copilots</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#installation">Installation</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#dataset-editor">Dataset Editor</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#evaluation">Evaluation</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#leaderboard">Leaderboard</a>
  </h3>
</div>

---

# Text2Model: LLM Modeling Copilots for Text-to-Model Translation

[Text2Model](https://skadio.github.io/text2model/) is a suite of LLM modeling copilots, datasets, fined-tuned models, demos, interactive editor, and online leaderboard for translating natural language text into formal combinatorial constraint models.

Text2Model uses MiniZinc as the target modeling language which makes our copilots both **paradigm- and solver-agnostic**. Our copilots generate models that can be solved by any MiniZinc compatible solver including Gecode, Chuffed, OR-Tools, CBC, Gurobi, Cplex, HiGH. This covers a wide range of paradigms including CP, CP-SAT, and MIP. As such, Text2Model can address **both combinatorial satisfaction and optimization problems.**

Please visit [Text2Model](https://skadio.github.io/text2model/) for latest publications and resources.

## Quick Start

Text2Model supports translating given problem descriptions (**Text mode**), or specific problems from our dataset (**Text2Zinc mode**).

### Text Mode

```bash
# Translate a given problem description
text2model --problem "A country produces fighter jets each year. Some of these jets must be set aside for pilot training instead of combat use. Year 1 production is 10 jets, and Year 2 production is 15 jets. Each training jet can train 5 pilots per year. Training runs for 2 years, starting in Year 1. Determine how many pilots will be trained in total by the end of Year 2."

# Translate a given problem file
text2model --problem my_problem.txt

# Choose the copilot strategy and the model
# Note that `knowledge_graph` is not available for text-mode as it requires pre-built TTL files
text2model --problem my_problem.txt --strategies agents_with_code_validation --model gpt-4o

# Redirect the output to a MiniZinc model
text2model --problem my_problem.txt > my_model.mzn
```

### Text2Zinc Mode

```bash
# Translate specific problems from Text2Zinc
text2model --problem-ids 0 1 2 --strategies cot --model gpt-4 --output-dir my_results

# Run multiple strategies on all Text2Zinc problems
text2model --strategies cot --model gpt-4 --output-dir my_results

# Run all strategies
text2model --strategies all --model gpt-4 --output-dir my_results

# Run on specific source of Text2Zinc problems
text2model --source nlp4lp --strategies cot --model gpt-4 --output-dir my_results

# List all available data sources
text2model --list-sources

# List all available --model options (which need OPENAI_API_KEY vs. run locally through Ollama)
text2model --list-models

# Advanced options
text2model --strategies agents --model gpt-4 \
  --output-dir my_results \
  --temperature 0.7 \
  --max-tokens 8192 \
  --sleep-time 2 \
  --include-unverified

# Use a local dataset (e.g. one saved by `text2model --editor`) instead of the
# default skadio/text2zinc HuggingFace dataset
text2model --strategies cot --model gpt-4 --output-dir my_results \
  --dataset-path text2zinc_edited.csv
```

## Copilots

Text2Model offers different copilot strategies, ranging from simple single-call approaches to sophisticated multi-agent systems. Each makes different trade-offs between speed and accuracy.

| Strategy | Description                                                                                                                                                   |
|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `baseline` | Direct code generation from problem description. No special prompting. Good for simple problems or establishing a baseline.                                   |
| `cot` | **Chain-of-Thought** prompting with guiding principles. The LLM reasons through the problem step-by-step before generating code.                              |
| `knowledge_graph` | First extracts structured information (entities, relationships) from the problem, then generates code from this intermediate representation.                  |
| `cot_with_code_validation` | Generates code with CoT, then validates and fixes any compilation errors. Good default choice.                                                                |
| `cot_with_grammar_validation` | Generates code with CoT, then checks against MiniZinc grammar rules.                                                                                          |
| `cot_with_code_and_grammar_validation` | Combines CoT generation with both grammar checking and code validation.                                                                                       |
| `agents` | Decomposes the task into specialized agents: (1) parameters & variables, (2) constraints, (3) objective, (4) assembler that stitches everything together.     |
| `agents_with_code_validation` | Agents approach plus a final validation/fix step.                                                                                                            |
| `gala` | Global Agents for different constraint types (all_different, cumulative, etc.) plus an assembler. See the [GALA paper](https://arxiv.org/abs/2509.08970).|

> **Want to use `knowledge_graph` on your own problems?** It requires a pre-built `.ttl` knowledge-graph file per problem. See [`text2model/generate_knowledge_graph.py`](text2model/generate_knowledge_graph.py) and any example file under [`text2model/knowledge_graphs/`](text2model/knowledge_graphs/) (e.g. `nlp4lp_1.ttl`) and do similar — either adapt the script to your problem or hand-write a `.ttl` following the same structure.

### Adding a Custom Copilot

Every strategy in the table above follows the same shape, so plugging in a new one is mechanical:

1. **Add prompt(s)** under [`text2model/prompts/`](text2model/prompts/) (`.txt` files with `{problem_description}`, `{input_data}`, etc. placeholders — see any existing prompt for the pattern).
2. **Write a `run_<name>_strategy(client, model, problem, problem_identifier, output_dir)` function** in [`text2model/main.py`](text2model/main.py). Use `utils.prepare_problem_data`, `utils.get_effective_input_data`, and `utils.load_file` to build your prompt(s), call `utils.call_api(client, model, prompt)` to get code back, and stitch/combine calls the way `run_agents_strategy` does if your copilot needs multiple LLM calls. Finish with `utils.save_solution(output_dir, problem_identifier, code)`.
3. **Register it** by adding `'<name>': run_<name>_strategy` to `_STRATEGY_MAP` in `main.py`, and add `'<name>'` to the `--strategies` argparse `choices` list (and to the `'all'` expansion list if it should run as part of `--strategies all`).

That's it — your strategy is now available via `--strategies <name>` in both `--problem` and batch modes.

## Installation

Text2Model requires **Python 3.8+** and can be installed from PyPI or by building from source.

### Set Your API Key

```bash
export OPENAI_API_KEY="your-api-key-here"
```

### Install from PyPI
```bash
pip install text2model
```

### Install from Source
```bash
git clone https://github.com/skadio/text2model.git
cd text2model
pip install -e .
```

## Dataset Editor

Text2Model ships a GUI editor for browsing and editing Text2Zinc problems (input.json, data.dzn, model.mzn, output.json), running them through MiniZinc, and chatting with an AI assistant for help rephrasing descriptions or fixing model code.

### Install

The editor uses [Flet](https://flet.dev) and is an optional extra, so the base `text2model` install stays lightweight:

```bash
pip install "text2model[editor]"
```

### Launch

```bash
text2model --editor
```

By default the editor opens, in order: a previous editing session (`text2zinc_edited.csv` in the current directory), otherwise the dataset bundled with the package. Use the **"Load from HuggingFace"** button inside the editor to instead start from a fresh copy of `skadio/text2zinc`, or open any other local dataset with **"Open CSV..."** — or non-interactively:

```bash
text2model --editor --dataset-path my_dataset.csv
```

### Save and Benchmark

- **Save** (or Ctrl+S) quick-saves your edits to `text2zinc_edited.csv` in the current directory.
- **Save As New Dataset...** exports to any path you choose. That path is a complete Text2Zinc dataset you can pass to `--dataset-path` to generate or benchmark against your edits instead of the default HuggingFace dataset:

```bash
text2model --strategies cot --model gpt-4 --output-dir my_results --dataset-path my_dataset.csv
python evals/evaluate.py --output-dir my_results --dataset-path my_dataset.csv
```

## Evaluation

After generating models, evaluate their correctness via [`evals/evaluate.py`](evals/evaluate.py). This script compiles and runs each generated MiniZinc model against test instances, checking for both execution success and solution correctness.

#### Prerequisite

Install MiniZinc solver: https://www.minizinc.org/doc-2.5.5/en/installation.html

#### Evals
```bash
# Evaluate all generated code
# `--output-dir` is required. Point it at the directory produced by the batch-mode `text2model` run.
python evals/evaluate.py --output-dir my_results

# Evaluate against a local dataset (e.g. one saved by `text2model --editor`) instead
# of the default skadio/text2zinc HuggingFace dataset
python evals/evaluate.py --output-dir my_results --dataset-path text2zinc_edited.csv
```

Running the eval generates a JSON file (`evaluation_results.json` by default, via `--output-json`) with your accuracy metrics. You can PR that file to the [Text2Model Leaderboard](https://huggingface.co/spaces/skadio/text2model-leaderboard) on Hugging Face to get your results added to the online leaderboard.

#### Metrics

| Metric | Description |
|--------|-------------|
| **Execution Accuracy** | % of models that compile and run without errors |
| **Solution Accuracy** | % of models that produce correct solutions |
| **Average Score** | Average of execution and solution accuracy |

Results are broken down by problem type as satisfaction vs. optimization.

## Leaderboard

Text2Model hosts an online leaderboard tracking execution accuracy, solution accuracy, and average score across models and copilot strategies on the Text2Zinc benchmark:

**[Text2Model Leaderboard](https://huggingface.co/spaces/skadio/text2model-leaderboard)** (Hugging Face Spaces)

## Testing

Install test dependencies with `pip install -e ".[test]"`.

**Default tests** (`tests/test_main.py`, `tests/test_utils.py`) do not need an API key, network, or MiniZinc.
They are pure logic tests with mocked API calls and is run by the CI:

```bash
pytest -m "not integration"
```

**Integration tests** (`tests/test_integration.py`) hit real external dependencies and are opt-in only.
This is not to be used in CI:
- MiniZinc tests run the real `minizinc` binary and are skipped unless it is on `PATH`.
- The OpenAI test makes exactly one real, cheap, token-capped call (`gpt-4o-mini`, `max_tokens=20`) and is skipped unless `OPENAI_API_KEY` is set. It's intentionally not exhaustive to avoid API costs.

To run everything locally (with `OPENAI_API_KEY` set and MiniZinc installed):

```bash
pytest -m ""
```

## Repository Structure
```
text2model/
├── text2model/                  # Installable Python package
│   ├── prompts/                 # Prompt templates for each strategy
│   │   ├── cot_prompt.txt
│   │   ├── code_validation_prompt.txt
│   │   ├── global_constraint_prompts/
│   │   └── ...
│   ├── knowledge_graphs/        # KG files (.ttl) for knowledge_graph strategy
│   ├── editor/                  # Dataset editor GUI (`text2model --editor`, optional `[editor]` extra)
│   │   ├── app.py               # Flet app: browse/edit/execute Text2Zinc problems, AI chat assistant
│   │   └── data/text2zinc.csv   # Bundled default dataset the editor opens on first run
│   ├── grammar.mzn              # MiniZinc grammar for validation
│   ├── main.py                  # Copilot strategies and CLI entry point
│   ├── generate_knowledge_graph.py  # Generates KGs for the knowledge_graph strategy
│   └── utils.py                 # Shared utilities (API calls, validation, dataset loading)
├── tests/                       # Unit and integration tests (pytest)
├── evals/                       # Evaluation tooling
│   ├── evaluate.py              # Evaluates generated MiniZinc models
│   └── evaluation_results.json  # Latest evaluation results (PR-able to the HF leaderboard)
├── output/                      # Original outputs per strategy, kept for reproducing paper results
│   ├── [model]/[strategy]/      # e.g., gpt-4/cot/problem_1.mzn
│   └── evaluation_results/      # Accuracy metrics and leaderboard
├── pyproject.toml               # Package metadata and install config
├── CHANGELOG.txt                # Release history
└── LICENSE                      # Apache License 2.0
```

## Support

Please submit bug reports and feature requests as [Issues](https://github.com/skadio/text2model/issues).

## License

Text2Model is licensed under the [Apache License 2.0](LICENSE).

<br>
