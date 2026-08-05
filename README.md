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
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#interactive-mode">Interactive Mode</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#copilots">Copilots</a> •
    <a href="https://github.com/skadio/text2model?tab=readme-ov-file#small-language-models-slms">Small Language Models (SLMs)</a> •
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

Text2Model supports translating given problem descriptions (**Text mode**), specific problems from our dataset (**Text2Zinc mode**), or running the interactive editor (**Editor mode**).

### Text Mode

```bash
# Translate a given problem description
text2model --problem "A country produces fighter jets each year. Some of these jets must be set aside for pilot training instead of combat use. Year 1 production is 10 jets, and Year 2 production is 15 jets. Each training jet can train 5 pilots per year. Training runs for 2 years, starting in Year 1. Determine how many pilots will be trained in total by the end of Year 2."

# Translate a given problem file
text2model --problem my_problem.txt

# Choose the copilot strategy and the model
# `knowledge_graph`: uses the pre-built .ttl if one exists for the problem,
# otherwise generates one on the fly with an extra LLM call.
text2model --problem my_problem.txt --strategies agents_with_code --model gpt-4o

# Redirect the output to a MiniZinc model
text2model --problem my_problem.txt > my_model.mzn
```

### Text2Zinc Mode

```bash
# Translate specific problems from Text2Zinc, by index and/or identifier
# (identifiers match the dataset's "identifier" metadata field and output/.ttl
# filenames; use `--list-problem-ids` to see what's available)
text2model --problem-ids 0 1 nlp4lp_58 --strategies cot --model gpt-4 --output-dir my_results

# List problem indices/identifiers available to pass to --problem-ids
text2model --list-problem-ids --source nlp4lp

# Run multiple strategies on all Text2Zinc problems
text2model --strategies cot --model gpt-4 --output-dir my_results

# Run all strategies
text2model --strategies all --model gpt-4 --output-dir my_results

# Run on specific source of Text2Zinc problems
text2model --source nlp4lp --strategies cot --model gpt-4 --output-dir my_results

# List all available data sources
text2model --list-sources

# List all available --model options (OpenAI via OPENAI_API_KEY, local through
# Ollama, or local Hugging Face checkpoints loaded in-process via unsloth)
text2model --list-models

# Advanced options
text2model --strategies agents --model gpt-4 \
  --output-dir my_results \
  --temperature 0.7 \
  --max-tokens 8192 \
  --sleep-time 2 \
  --full-dataset

# Reasoning-effort hint (gpt-5.5 / gpt-5.6 only; ignored by other models,
# including gpt-4o/gpt-5.2 which are also reasoning models but don't take
# this hint). One of: none, low, medium, high, xhigh, max ("max" is
# gpt-5.6 only).
text2model --strategies cot --model gpt-5.5 --output-dir my_results \
  --reasoning-effort high

# Use a local dataset (e.g. one saved by `text2model --editor`) instead of the
# default skadio/text2zinc HuggingFace dataset
text2model --strategies cot --model gpt-4 --output-dir my_results \
  --text2zinc-path text2zinc_edited.csv

# Force a fresh download of skadio/text2zinc instead of reusing whatever is in
# the local HuggingFace datasets cache
text2model --strategies cot --model gpt-4 --output-dir my_results \
  --upgrade-text2zinc
```

`skadio/text2zinc` is a **gated** dataset: without an HF token with approved
access, `--upgrade-text2zinc` fails loudly instead of silently reusing stale
cache. Request access at
[huggingface.co/datasets/skadio/text2zinc](https://huggingface.co/datasets/skadio/text2zinc),
then either run `huggingface-cli login` or set the `HF_TOKEN` environment
variable. On a HuggingFace Space, add `HF_TOKEN` as a **Repository secret**
(Settings > Variables and secrets > New secret) instead — Spaces inject
secrets into the running container as environment variables at runtime,
without exposing them in code or the repo.

### Interactive Mode

```bash
# Text2Model offers an interactive editor for curating Text2Zinc problems
# It allows editing: input.json, data.dzn, model.mzn, output.json
# execution through MiniZinc, and an
# AI assistant to help problem, instance, model generation.
# AI Assistants has a simple harness to be aware of the current problem, data, model visible on the editor
text2model --editor

# Load from a local copy
text2model --editor --text2zinc-path text2zinc_edited.csv
```

## Copilots

Text2Model offers different copilot strategies, ranging from simple single-call approaches to sophisticated multi-agent systems. Each makes different trade-offs between speed and accuracy.

| Strategy | Description                                                                                                                                                   |
|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `baseline` | Direct code generation from problem description. No special prompting. Good for simple problems or establishing a baseline.                                   |
| `cot` | **Chain-of-Thought** prompting with guiding principles. The LLM reasons through the problem step-by-step before generating code.                              |
| `knowledge_graph` | First extracts structured information (entities, relationships) from the problem, then generates code from this intermediate representation.                  |
| `cot_with_code` | Generates code with CoT, then validates and fixes any compilation errors. Good default choice.                                                                |
| `cot_with_grammar` | Generates code with CoT, then checks against MiniZinc grammar rules.                                                                                          |
| `cot_with_code_and_grammar` | Combines CoT generation with both grammar checking and code validation.                                                                                       |
| `agents` | Decomposes the task into specialized agents: (1) parameters & variables, (2) constraints, (3) objective, (4) assembler that stitches everything together.     |
| `agents_with_code` | Agents approach plus a final validation/fix step.                                                                                                            |
| `gala` | Global Agents for different constraint types (all_different, cumulative, etc.) plus an assembler. See the [GALA paper](https://arxiv.org/abs/2509.08970).|

> **`knowledge_graph` on your own problems**: if no `.ttl` exists for the problem under [`text2model/knowledge_graphs/`](text2model/knowledge_graphs/), one is generated on the fly with an extra LLM call. To pre-build and curate your own instead, see [`text2model/generate_knowledge_graph.py`](text2model/generate_knowledge_graph.py) or hand-write a `.ttl` following the structure of an existing example (e.g. `nlp4lp_1.ttl`).

### Adding a Custom Copilot

Every strategy in the table above follows the same shape, so plugging in a new one is mechanical:

1. **Add prompt(s)** under [`text2model/prompts/`](text2model/prompts/) (`.txt` files with `{problem_description}`, `{input_data}`, etc. placeholders — see any existing prompt for the pattern).
2. **Write a `run_<name>_strategy(client, model, problem, problem_identifier, output_dir)` function** in its own module under [`text2model/copilots/`](text2model/copilots/). Use `utils.prepare_problem_data`, `utils.get_effective_input_data`, and `utils.load_file` to build your prompt(s), call `utils.call_api(client, model, prompt)` to get code back, and stitch/combine calls the way `copilots/agents.py` does if your copilot needs multiple LLM calls. Finish with `utils.save_solution(output_dir, problem_identifier, code)`.
3. **Register it** by importing your function and adding `'<name>': run_<name>_strategy` to `STRATEGY_MAP` in [`text2model/copilots/__init__.py`](text2model/copilots/__init__.py), and add `'<name>'` to the `--strategies` argparse `choices` list in `main.py` (and to the `'all'` expansion list if it should run as part of `--strategies all`).

That's it — your strategy is now available via `--strategies <name>` in both `--problem` and batch modes.

## Small Language Models (SLMs)

Alongside API-based copilots, you can also load our own **small language models (SLMs) for generating MiniZinc code**, hosted on Hugging Face under the [skadio](https://huggingface.co/skadio) org. They run locally as `--model` options alongside OpenAI/Ollama models — see [`text2model/huggingface.py`](text2model/huggingface.py) for details. Set `HF_TOKEN` in your environment before using these (see [Set Your API Keys](https://github.com/skadio/text2model?tab=readme-ov-file#set-your-api-keys)).

**Requires an NVIDIA or Intel GPU.** Install the extra GPU dependencies into the same environment as the rest of text2model:

```bash
pip install "text2model[gpu]" --extra-index-url https://download.pytorch.org/whl/cu126
```

This stack breaks easily across releases, so see the comment above `[project.optional-dependencies]` in [`pyproject.toml`](pyproject.toml) if you need to change any pinned versions.

| Model (`--model` alias) | Base Model | Hugging Face Repo |
|---|---|---|
| `learn2zinc-gpt-oss-20b` | gpt-oss-20B | [skadio/learn2zinc-GPT-oss-20B](https://huggingface.co/skadio/learn2zinc-GPT-oss-20B) |
| `learn2zinc-qwen3-0.6b` | Qwen3-0.6B | [skadio/learn2zinc-Qwen3-0.6B](https://huggingface.co/skadio/learn2zinc-Qwen3-0.6B) |
| `learn2zinc-llama-3.2-1b` | Llama-3.2-1B | [skadio/learn2zinc-Llama-3.2-1B](https://huggingface.co/skadio/learn2zinc-Llama-3.2-1B) |
| `learn2zinc-llama-3.2-3b` | Llama-3.2-3B | [skadio/learn2zinc-Llama-3.2-3B](https://huggingface.co/skadio/learn2zinc-Llama-3.2-3B) |
| `learn2zinc-gemma-2-9b` | Gemma-2-9B | [skadio/learn2zinc-Gemma-2-9B](https://huggingface.co/skadio/learn2zinc-Gemma-2-9B) |

```bash
# Run a copilot strategy against a local small language model (SLM) from Hugging Face
text2model --problem my_problem.txt --strategies baseline --model learn2zinc-gpt-oss-20b
```

`learn2zinc-gpt-oss-20b` is our best-performing open-source model.

## Installation

Text2Model requires **Python 3.8+** and can be installed from PyPI or by building from source.

### Set Your API Keys

```bash
export OPENAI_API_KEY="your-api-key-here"

# Only needed for the Hugging Face models under Small Language Models (SLMs) below.
# huggingface_hub/transformers pick this up automatically from the
# environment, no --api-key-style flag needed.
export HF_TOKEN="your-hugging-face-token-here"
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

## Evaluation

After generating models, evaluate their correctness via [`evals/evaluate.py`](evals/evaluate.py). This script compiles and runs each generated MiniZinc model against test instances, checking for both execution success and solution correctness.

#### Prerequisite

Install MiniZinc solver: https://www.minizinc.org/doc-2.5.5/en/installation.html

#### Evals
```bash
# Run strategies in batch-mode
text2model --strategies cot --model gpt-4 --output-dir my_results --text2zinc-path text2zinc_edited.csv

# Evaluate all generated code. `--output-dir` is required to point the directory produced by the batch-mode `text2model` run.
python evals/evaluate.py --output-dir my_results

# Evaluate against a local dataset (e.g. one saved by `text2model --editor`) instead of the default HuggingFace dataset
python evals/evaluate.py --output-dir my_results --text2zinc-path text2zinc_edited.csv
```

Running the eval generates a JSON file (`evals/evaluation_results.json` by default, via `--output-json`) with your accuracy metrics. You can PR that file to the [Text2Model Leaderboard](https://huggingface.co/spaces/skadio/text2model-leaderboard) on Hugging Face to get your results added to the online leaderboard.

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

**Default tests** (`tests/test_main.py`, `tests/test_utils.py`) do not need an API key, network, or MiniZinc.
They are pure logic tests with mocked API calls and is run by the CI:

```bash
pytest -m "not integration"
```

**Integration tests** (`tests/test_integration.py`) hit real external dependencies and are opt-in only.
This is not to be used in CI:
- MiniZinc tests run the real `minizinc` binary and are skipped unless it is on `PATH`.
- The OpenAI tests are skipped unless `OPENAI_API_KEY` is set. Beyond a single cheap, token-capped smoke test, they include a real end-to-end sweep across every strategy and input mode (including multi-call strategies like `agents`/`gala`) plus several batch-mode runs, so they make many real API calls, not just one.

**Note:** running the full integration suite with `OPENAI_API_KEY` set will incur real, non-trivial API costs — don't run it casually, repeatedly, or in CI.

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
│   ├── editor/                  # Dataset editor GUI (`text2model --editor`)
│   │   └── app.py               # Flet app: browse/edit/execute Text2Zinc problems, AI chat assistant
│   │                             # (opens from HuggingFace on first run — no dataset is bundled)
│   ├── copilots/                # One module per copilot strategy, registered in STRATEGY_MAP
│   │   ├── baseline.py
│   │   ├── cot.py
│   │   ├── knowledge_graph.py
│   │   ├── cot_with_code.py
│   │   ├── cot_with_grammar.py
│   │   ├── cot_with_code_and_grammar.py
│   │   ├── agents.py
│   │   └── gala.py
│   ├── grammar.mzn              # MiniZinc grammar for validation
│   ├── main.py                  # CLI entry point: argparse, dataset loading, run orchestration
│   ├── generate_knowledge_graph.py  # Generates KGs for the knowledge_graph strategy
│   ├── huggingface.py           # Local Hugging Face models, loaded in-process via unsloth (no daemon, unlike Ollama)
│   └── utils.py                 # Shared utilities (API calls, validation, dataset loading)
├── tests/                       # Unit and integration tests (pytest)
├── evals/                       # Evaluation tooling
│   ├── evaluate.py              # Evaluates generated MiniZinc models
│   ├── evaluation_results.json  # Latest evaluation results (PR-able to the HF leaderboard)
│   └── results/                 # Accuracy metrics and leaderboard from paper runs
├── output/                      # Original outputs per strategy, kept for reproducing paper results
│   └── [model]/[strategy]/      # e.g., gpt-4/cot/problem_1.mzn
├── pyproject.toml               # Package metadata and install config
├── CHANGELOG.txt                # Release history
└── LICENSE                      # Apache License 2.0
```

## Support

Please submit bug reports and feature requests as [Issues](https://github.com/skadio/text2model/issues).

## License

Text2Model is licensed under the [Apache License 2.0](LICENSE).

<br>
