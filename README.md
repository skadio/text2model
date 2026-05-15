# Text2Model: LLM Modeling Copilots for Text-to-Model Translation

**Automatically translate natural language problem descriptions into executable optimization models.**

Text2Model provides AI-powered "copilots" that convert plain English descriptions of optimization and constraint satisfaction problems into [MiniZinc](https://www.minizinc.org/) code. Instead of manually coding constraints, variables, and objectives, describe your problem in natural language and let the copilot generate the model for you.

> Currently benchmarked on [Text2Zinc](https://huggingface.co/datasets/skadio/text2zinc), but applicable to any text-to-model task.

## What is MiniZinc?

[MiniZinc](https://www.minizinc.org/) is a high-level constraint modeling language used for solving optimization problems like scheduling, resource allocation, routing, and more. Text2Model bridges the gap between problem descriptions and MiniZinc code.

**Example:** You describe *"Schedule 5 nurses across 7 days ensuring no one works more than 5 days"* and the copilot generates the corresponding MiniZinc model.

---

## Copilot Strategies

Text2Model offers 9 different strategies, ranging from simple single-call approaches to sophisticated multi-agent systems. Each makes different trade-offs between speed and accuracy.

### Which Strategy Should I Use?

| Your Goal | Recommended Strategy | API Calls |
|-----------|---------------------|-----------|
| Quick prototype / testing | `baseline` or `cot` | 1 |
| Good balance of speed & quality | `cot_with_code_validation` | 2 |
| Structured reasoning first | `knowledge_graph` | 2 |
| High accuracy (willing to wait) | `agents_with_code_validation` | 5 |
| Maximum accuracy for complex problems | `gala` | Variable |

### Strategy Overview

#### Single LLM Call (Fastest)

| Strategy | Description |
|----------|-------------|
| `baseline` | Direct code generation from problem description. No special prompting. Good for simple problems or establishing a baseline. |
| `cot` | **Chain-of-Thought** prompting with guiding principles. The LLM reasons through the problem step-by-step before generating code. |

#### Two LLM Calls

| Strategy | Description |
|----------|-------------|
| `knowledge_graph` | First extracts structured information (entities, relationships) from the problem, then generates code from this intermediate representation. |
| `cot_with_code_validation` | Generates code with CoT, then validates and fixes any compilation errors. Good default choice. |
| `cot_with_grammar_validation` | Generates code with CoT, then checks against MiniZinc grammar rules. |

#### Three LLM Calls

| Strategy | Description |
|----------|-------------|
| `cot_with_code_and_grammar_validation` | Combines CoT generation with both grammar checking and code validation. |

#### Four+ LLM Calls (Most Thorough)

| Strategy | Description |
|----------|-------------|
| `agents` | Decomposes the task into specialized agents: (1) parameters & variables, (2) constraints, (3) objective, (4) assembler that stitches everything together. |
| `agents_with_code_validation` | Agents approach plus a final validation/fix step. |
| `gala` | **Global Agents** - Multiple specialized agents for different constraint types (all_different, cumulative, etc.) plus an assembler. See the [GALA paper](https://arxiv.org/abs/2509.08970). |

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

### 3. Generate Your First Model

```bash
# Run chain-of-thought on all problems
python main.py --strategies cot --model gpt-4

# Or try a quick test on specific problems
python main.py --strategies cot --problem-ids 0 1 2 --model gpt-4
```

---

## Usage

### Run Multiple Strategies

```bash
# Compare baseline vs chain-of-thought
python main.py --strategies baseline cot --model gpt-4o

# Run all 9 strategies
python main.py --strategies all --model gpt-4
```

### Filter by Problem Source

```bash
# List available data sources
python main.py --list-sources

# Run on specific source
python main.py --strategies cot --model gpt-4 --source nlp4lp
```

### Advanced Options

```bash
python main.py --strategies agents --model gpt-4 \
  --temperature 0.7 \
  --max-tokens 8192 \
  --sleep-time 2 \
  --include-unverified
```

---

## Evaluation

After generating models, evaluate their correctness:

### Prerequisites

Install MiniZinc solver: https://www.minizinc.org/doc-2.5.5/en/installation.html

### Run Evaluation

```bash
# Evaluate all generated code
python evaluate.py
```

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
├── main.py                      # Main entry point - runs copilot strategies
├── evaluate.py                  # Evaluates generated MiniZinc models
├── utils.py                     # Shared utilities (API calls, validation)
├── generate_knowledge_graph.py  # Generates KGs for knowledge_graph strategy
├── grammar.mzn                  # MiniZinc grammar for validation
├── prompts/                     # Prompt templates for each strategy
│   ├── cot_prompt.txt
│   ├── code_validation_prompt.txt
│   ├── global_constraint_prompts/
│   └── ...
├── output/                      # Generated models (created automatically)
│   ├── [model]/[strategy]/      # e.g., gpt-4/cot/problem_1.mzn
│   └── evaluation_results/      # Accuracy metrics and leaderboard
└── knowledge_graphs/            # Generated KG files (.ttl)
```

---

## Resources

### Papers
- [GALA: Global LLM Agents for Text-to-Model Translation](https://arxiv.org/abs/2509.08970)
- [Text2Zinc: A Cross-Domain Dataset for Modeling Optimization and Satisfaction Problems](https://arxiv.org/abs/2503.10642)
- [Ner4Opt: Named Entity Recognition for Optimization](https://link.springer.com/article/10.1007/s10601-024-09376-5) | [GitHub](https://github.com/skadio/ner4opt)

### Dataset & Tools
- [Text2Zinc Dataset](https://huggingface.co/datasets/skadio/text2zinc) - 110+ verified constraint programming problems
- [Text2Zinc Editor](https://huggingface.co/spaces/skadio/text2zinc-editor) - Interactive problem editor
- [Text2Model Leaderboard](https://huggingface.co/spaces/skadio/text2model-leaderboard) - Compare strategy performance
