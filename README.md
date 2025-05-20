# MiniZinc Code Generation Pipeline

A unified pipeline for generating MiniZinc code using different prompting strategies with OpenAI's GPT models.

## Project Structure

```
.
├── main.py                 # Main script to run all strategies
├── utils.py               # Utility functions for common operations
├── prompts/               # Directory for prompt templates
│   ├── cot_prompt.txt
│   ├── validation_prompt.txt
│   ├── kg_code_generation_prompt.txt
│   ├── parameter_and_variable_generation_prompt.txt
│   ├── constraint_generation_prompt.txt
│   ├── objective_generation_prompt.txt
│   └── code_generation_prompt.txt
├── knowledge_graphs/      # Directory for knowledge graph files
│   └── problem_N.ttl
├── output/               # Output directory (created automatically)
│   ├── gpt-4/
│   │   ├── vanilla/
│   │   ├── two_stage/
│   │   ├── knowledge_graph/
│   │   ├── stitch/
│   │   └── summary.json
│   └── gpt-4o/
│       └── ...
└── README.md
```

## Setup

1. Install dependencies:
```bash
pip install openai datasets tqdm
```

2. Set your OpenAI API key:
```bash
export OPENAI_API_KEY="your-api-key-here"
```

3. Create the prompts directory and add your prompt files (see below for expected files)

## Usage

### Run all strategies on all problems:
```bash
python main.py --strategies all --model gpt-4
```

### Run specific strategies:
```bash
python main.py --strategies vanilla two_stage --model gpt-4o
```

### Run on specific problem IDs:
```bash
python main.py --strategies vanilla --problem-ids 0 1 2 10 --model gpt-4
```

### Custom parameters:
```bash
python main.py --strategies all \
              --model gpt-4o \
              --output-dir custom_output \
              --temperature 0.1 \
              --max-tokens 2048 \
              --sleep-time 5
```

## Available Strategies

1. **vanilla**: Simple single-prompt generation
2. **two_stage**: Chain of thought followed by validation
3. **knowledge_graph**: Uses knowledge graphs for enhanced generation
4. **stitch**: Compositional approach breaking down into subtasks

## Command Line Arguments

- `--model`: OpenAI model to use (gpt-4, gpt-4o)
- `--strategies`: Strategies to run (vanilla, two_stage, knowledge_graph, stitch, all)
- `--problem-ids`: Specific problem IDs to process (space-separated list)
- `--output-dir`: Base output directory (default: output)
- `--api-key`: OpenAI API key (defaults to OPENAI_API_KEY env var)
- `--temperature`: Temperature for API calls (default: 0)
- `--max-tokens`: Max tokens for API calls (default: 4096)
- `--sleep-time`: Sleep time between API calls in seconds (default: 3)

## Required Prompt Files

Create these files in the `prompts/` directory:

1. `cot_prompt.txt`: Chain of thought prompt
2. `validation_prompt.txt`: Validation prompt
3. `kg_code_generation_prompt.txt`: Knowledge graph enhanced prompt
4. `parameter_and_variable_generation_prompt.txt`: Parameter generation prompt
5. `constraint_generation_prompt.txt`: Constraint generation prompt
6. `objective_generation_prompt.txt`: Objective generation prompt
7. `code_generation_prompt.txt`: Final code generation prompt

For the knowledge graph strategy, ensure you have `.ttl` files in the `knowledge_graphs/` directory named as `problem_N.ttl` where N is the problem index.

## Output

Generated MiniZinc files are saved in a hierarchical structure:
```
output/
├── [model_name]/
│   ├── [strategy_name]/
│   │   ├── problem_0.mzn
│   │   ├── problem_1.mzn
│   │   └── ...
│   └── summary.json
├── evaluation_results/
│   ├── [model_name]/
│   │   ├── [strategy_name]/
│   │   │   ├── summary.json
│   │   │   └── detailed_results.json
│   │   └── ...
│   └── leaderboard.csv
```

The `summary.json` file contains success/failure counts for each strategy.

## Evaluation

After generating MiniZinc code, you can evaluate the results:

### Prerequisites
- Install MiniZinc: https://www.minizinc.org/doc-2.5.5/en/installation.html
- Ensure `minizinc` is in your PATH

### Evaluate all generated code:
```bash
python evaluate.py
```

### Evaluate specific model:
```bash
python evaluate.py --model gpt-4
```

### Evaluate specific strategy:
```bash
python evaluate.py --model gpt-4 --strategy vanilla
```

### Customize evaluation:
```bash
python evaluate.py --timeout 120 --solver chuffed
```

### Create leaderboard from existing results:
```bash
python evaluate.py --create-leaderboard-only
```

The evaluation will:
1. Load problems from the HuggingFace dataset
2. Run each generated MiniZinc file with the corresponding data
3. Compare outputs with expected solutions
4. Calculate execution and solution accuracy
5. Generate a leaderboard comparing all strategies

## Evaluation Metrics

- **Execution Accuracy**: Percentage of problems that run without errors
- **Solution Accuracy**: Percentage of problems with correct solutions
- **Average Score**: Average of execution and solution accuracy

Results are broken down by:
- Overall performance
- Satisfaction problems
- Optimization problems