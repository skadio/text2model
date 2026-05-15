# Text2Model: LLM Modeling Copilots for Text-to-Model Translation

Text-to-model translation is the task of converting natural language descriptions of combinatorial problems into formal constraint models. 

[Text2Model](https://skadio.github.io/text2model/) is a suite of LLM modeling copilots, datasets, fined-tuned models, demos, interactive editor, and online leaderboard for translating natural language text into formal combinatorial constraint models.

Text2Model uses MiniZinc as the target modeling language which makes our copilots both **paradigm- and solver-agnostic**. Our copilots generate models that can be solved by any MiniZinc compatible solver including Gecode, Chuffed, OR-Tools, CBC, Gurobi, Cplex, HiGH. This covers a wide range of paradigms including CP, CP-SAT, and MIP. As such, Text2Model can address **both combinatorial satisfaction and optimization problems.**

Please visit [Text2Model](https://skadio.github.io/text2model/) for latest publications and resources. 

---

## Text2Model Copilots

Text2Model offers different strategies, ranging from simple single-call approaches to sophisticated multi-agent systems. Each makes different trade-offs between speed and accuracy.

| Strategy | Description                                                                                                                                                    |
|----------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `baseline` | Direct code generation from problem description. No special prompting. Good for simple problems or establishing a baseline.                                    |
| `cot` | **Chain-of-Thought** prompting with guiding principles. The LLM reasons through the problem step-by-step before generating code.                               |
| `knowledge_graph` | First extracts structured information (entities, relationships) from the problem, then generates code from this intermediate representation.                   |
| `cot_with_code_validation` | Generates code with CoT, then validates and fixes any compilation errors. Good default choice.                                                                 |
| `cot_with_grammar_validation` | Generates code with CoT, then checks against MiniZinc grammar rules.                                                                                           |
| `cot_with_code_and_grammar_validation` | Combines CoT generation with both grammar checking and code validation.                                                                                        |
| `agents` | Decomposes the task into specialized agents: (1) parameters & variables, (2) constraints, (3) objective, (4) assembler that stitches everything together.      |
| `agents_with_code_validation` | Agents approach plus a final validation/fix step.                                                                                                             |
| `gala` | Global Agents for different constraint types (all_different, cumulative, etc.) plus an assembler. See the [GALA paper](https://arxiv.org/abs/2509.08970).      |


---

## Quick Start

### 1. Install Dependencies

```bash
pip install openai datasets tqdm langchain_ollama
```

### 2. Set Your API Key

```bash
export OPENAI_API_KEY="your-api-key-here"
```

### 3. Create Your First LLM Generated Model

```bash
# Try a quick test on specific problems
python main.py --strategies cot --problem-ids 0 1 2 --model gpt-4 --output-dir my_results

# Or run chain-of-thought on all problems
python main.py --strategies cot --model gpt-4 --output-dir my_results
```

---

## Usage

### Run Multiple Strategies

```bash
# Compare baseline vs chain-of-thought
python main.py --strategies baseline cot --model gpt-4o --output-dir my_results

# Run all 9 strategies
python main.py --strategies all --model gpt-4 --output-dir my_results
```

### Filter by Problem Source

```bash
# List available data sources
python main.py --list-sources

# Run on specific source
python main.py --strategies cot --model gpt-4 --source nlp4lp --output-dir my_results
```

### Advanced Options

```bash
python main.py --strategies agents --model gpt-4 \
  --output-dir my_results \
  --temperature 0.7 \
  --max-tokens 8192 \
  --sleep-time 2 \
  --include-unverified
```

---

## Evaluation

After generating models, evaluate their correctness via `evaluate.py`. This script compiles and runs each generated MiniZinc model against test instances, checking for both execution success and solution correctness.

### Prerequisites

Install MiniZinc solver: https://www.minizinc.org/doc-2.5.5/en/installation.html

### Run Evaluation
```bash
# Evaluate all generated code
python evaluate.py --output-dir my_results
```

> **Note:** `--output-dir` is required. Point it at the directory produced by `main.py`.

### Metrics

| Metric | Description |
|--------|-------------|
| **Execution Accuracy** | % of models that compile and run without errors |
| **Solution Accuracy** | % of models that produce correct solutions |
| **Average Score** | Average of execution and solution accuracy |

Results are broken down by problem type (satisfaction vs optimization).

---

## Repository Structure

```
text2model/
├── knowledge_graphs/            # Generated KG files (.ttl)
├── output/                      # Generated models (created automatically)
│   ├── [model]/[strategy]/      # e.g., gpt-4/cot/problem_1.mzn
│   └── evaluation_results/      # Accuracy metrics and leaderboard
├── prompts/                     # Prompt templates for each strategy
│   ├── cot_prompt.txt
│   ├── code_validation_prompt.txt
│   ├── global_constraint_prompts/
│   └── ...
├── evaluate.py                  # Evaluates generated MiniZinc models
├── generate_knowledge_graph.py  # Generates KGs for knowledge_graph strategy
├── grammar.mzn                  # MiniZinc grammar for validation
├── main.py                      # Copilot strategies
└── utils.py                     # Shared utilities (API calls, validation)
```
