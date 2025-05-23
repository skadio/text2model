# MiniZinc Code Generation using LLMs

A unified pipeline for generating MiniZinc code using different prompting strategies with OpenAI's GPT models.

## Setup

1. Install dependencies:
```bash
pip install openai datasets tqdm
```

2. Set your OpenAI API key:
```bash
export OPENAI_API_KEY="your-api-key-here"
```

## Usage

### Run all strategies on all problems:
```bash
python main.py --strategies all --model gpt-4
```

### Run specific strategies:
```bash
python main.py --strategies baseline cot --model gpt-4o
```

### Run on specific problem IDs:
```bash
python main.py --strategies vanilla --problem-ids 0 1 2 10 --model gpt-4
```

## Available Strategies

### Single API call
1. **baseline**: This is a naive approach to generate Minizinc code prompting LLMs without any explicit instructions except the problem and data description.
2. **cot**: This approach uses a chain intermediate steps/thoughts and general guiding principles when generating Minizinc code.

### Two API calls
1. **knowledge_graph**: This approach generates a structured knowledge graph representation of important information in the problem, followed by the code generation building on the intermediate structured representation generated.
2. **cot_with_code_validation**: This approach combines chain-of-thought with an additional step of code validation with a generic checklist to improve the previously generated code.
3. **cot_with_grammar_validation**: This approach combines, chain-of-thought with an additional step to check grammar using Minizinc Context Free Grammar.

### Three API calls
1. **cot_with_code_and_grammar_validation**: This approach combines, chain-of-thought with two additional steps, one to check grammar using Minizinc Context Free Grammar and code validation explained previously.

### Four API calls
1. **compositional**: This approach splits the code generation into four steps, generate parameters & variables, constraints, objective and a final prompt to stitch these intermediate outputs together.

### Five API calls
1. **compositional_with_code_validation**: This approach adds a code validation step to compositional approach.

## Evaluation

After generating MiniZinc code, you can evaluate the results:

### Prerequisites
- Install MiniZinc: https://www.minizinc.org/doc-2.5.5/en/installation.html
- Ensure `minizinc` is in your PATH

### Evaluate all generated code:
```bash
python evaluate.py
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

### Current Leaderboard
| model  | strategy                             | execution_accuracy | solution_accuracy | average_score | problems_attempted | problems_solved | evaluation_date     |
|--------|--------------------------------------|--------------------|-------------------|---------------|--------------------|-----------------|---------------------|
| gpt-4o | cot_with_code_validation             | 80.91              | 41.82             | 61.36         | 110                | 46              | 2025-05-22 13:32:11 |
| gpt-4o | cot_with_code_and_grammar_validation | 73.64              | 40.0              | 56.82         | 110                | 44              | 2025-05-22 13:36:30 |
| gpt-4o | cot                                  | 60.91              | 34.55             | 47.73         | 110                | 38              | 2025-05-22 13:34:29 |
| gpt-4  | cot_with_code_and_grammar_validation | 70.0               | 24.55             | 47.27         | 110                | 27              | 2025-05-22 13:50:56 |
| gpt-4  | cot_with_grammar_validation          | 62.73              | 22.73             | 42.73         | 110                | 25              | 2025-05-22 13:38:44 |
| gpt-4  | cot                                  | 57.27              | 28.18             | 42.73         | 110                | 31              | 2025-05-22 13:49:54 |
| gpt-4  | cot_with_code_validation             | 57.27              | 28.18             | 42.73         | 110                | 31              | 2025-05-22 13:42:43 |
| gpt-4  | knowledge_graph                      | 48.18              | 25.45             | 36.82         | 110                | 28              | 2025-05-22 13:37:45 |
| gpt-4  | compositional_with_code_validation   | 43.64              | 20.91             | 32.27         | 110                | 23              | 2025-05-22 13:41:40 |
| gpt-4  | compositional                        | 43.64              | 20.0              | 31.82         | 110                | 22              | 2025-05-22 13:46:05 |
| gpt-4  | baseline                             | 32.73              | 17.27             | 25.0          | 110                | 19              | 2025-05-22 13:48:56 |


## Repository Structure

```
├── knowledge_graphs/                                            # Directory for knowledge graph files
│   └── problem_N.ttl
├── output/                                                      # Output directory (created automatically)
│   ├── gpt-4/
│   │   ├── vanilla/
│   │   ├── two_stage/
│   │   ├── knowledge_graph/
│   │   ├── stitch/
│   │   └── summary.json
│   └── gpt-4o/
│       └── ...
├── prompts/                                                     # Directory for prompt templates
│   ├── code_generation_prompt.txt
│   ├── constraint_generation_prompt.txt
│   ├── cot_prompt.txt
│   ├── kg_generation_prompt.txt
│   ├── objective_generation_prompt.txt
│   ├── parameter_and_varaible_generation_prompt.txt
│   └── validation_prompt.txt
├── generate_knowledge_graph.py                                  # Script to generate knowledge graphs
├── grammar.mzn                                                  # MiniZinc grammar (https://github.com/MiniZinc/libminizinc/blob/master/docs/en/grammar.mzn)
├── main.py                                                      # Main script to run all strategies
├── utils.py                                                     # Utility functions for common operations
└── README.md
```

### Output Folder Structure

Generated MiniZinc files are saved in a hierarchical structure:
```
output/
├── [model_name]/
│   ├── [strategy_name]/
│   │   ├── problem_0.mzn
│   │   ├── problem_1.mzn
│   │   └── ...
│   └── ...
├── evaluation_results/
│   ├── [model_name]/
│   │   ├── [strategy_name]/
│   │   │   ├── summary.json
│   │   │   └── detailed_results.json
│   │   └── ...
│   └── leaderboard.csv
```
- `summary.json` inside each strategy contains overall success/failure counts for each strategy
- `detailed_results.json` inside each strategy contains
  - `problem_id`: Current problem id
  - `problem_type`: Problem type, either optimization or satisfaction
  - `execution_success`: If the problem executed correctly
  - `solution_success`: If the problem solution matches the ground truth
  - `timeout`: Timeout used for running the model
  - `solver`: Solver used for running the model
  - `output`: Output of the execution
- `leaderboard.csv`: Summary of all strategies and their corresponding metrics