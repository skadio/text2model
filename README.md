# Text2Model: LLM Modeling Copilots for Text-to-Model Translation

Please visit [Text2Model](https://skadio.github.io/text2model/) for the latest updates, documentation, and resources.

## Setup

1. Install dependencies:
```bash
pip install openai datasets tqdm langchain_ollama
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
python main.py --strategies baseline --problem-ids 0 1 2 10 --model gpt-4
```

## Text2Model Copilots

### Single API/LLM call
1. **baseline**: This is a naive approach to generate Minizinc code prompting LLMs without any explicit instructions except the problem and data description.
2. **cot**: This approach uses a chain intermediate steps/thoughts and general guiding principles when generating Minizinc code.

### Two API/LLM calls
1. **knowledge_graph**: This approach generates a structured knowledge graph representation of important information in the problem, followed by the code generation building on the intermediate structured representation generated.
2. **cot_with_code_validation**: This approach combines chain-of-thought with an additional step of code validation with a generic checklist to improve the previously generated code.
3. **cot_with_grammar_validation**: This approach combines, chain-of-thought with an additional step to check grammar using Minizinc Context Free Grammar.

### Three API/LLM calls
1. **cot_with_code_and_grammar_validation**: This approach combines, chain-of-thought with two additional steps, one to check grammar using Minizinc Context Free Grammar and code validation explained previously.

### Four API/LLM calls
1. **agents**: This agents approach splits the code generation into four steps, generate parameters & variables, constraints, objective and a final prompt to stitch these intermediate outputs together.

### Five API/LLM calls
1. **agents_with_code_validation**: This agents approach adds a code validation step to the agents approach.

### Multiple API/LLM calls
1. **global_agents**: This global agents approach first have individual agents focusing on every type of specific global constraints and get the code output. Then it have an assembler to combine the code together. See Gala paper. 

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
1. Load problems from the [HuggingFace dataset](https://huggingface.co/datasets/skadio/text2zinc)
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

## Leaderboard 
[Text2Model-Leaderboard](https://huggingface.co/spaces/skadio/text2model-leaderboard)

## Repository Structure

```
├── knowledge_graphs/                                            # Directory for knowledge graph files
│   └── `problem_identifier`.ttl                                 # e.g. problem_identifier: `non_linear_problem_9` from the dataset
│   └── ...
├── output/                                                      # Output directory (created automatically)
│   ├── gpt-4/
│       └── ...
│   └── gpt-4o/
│       └── ...
├── prompts/                                                     # Directory for prompt templates
└── ...
├── evaluate.py                                                  # Script to evaluate generated minizinc code
├── generate_knowledge_graph.py                                  # Script to generate knowledge graphs
├── grammar.mzn                                                  # MiniZinc grammar (https://github.com/MiniZinc/libminizinc/blob/master/docs/en/grammar.mzn)
├── main.py                                                      # Main script to run all strategies
├── utils.py                                                     # Utility functions for common operations
└── README.md
```

## Output Folder Structure

Generated MiniZinc files are saved in a hierarchical structure:
```
output/
├── [model_name]/
│   ├── [strategy_name]/
│   │   ├── `problem_identifier`.mzn
│   │   └── ...
│   └── ...
├── evaluation_results/
│   ├── [model_name]/
│   │   ├── [strategy_name]/
│   │   │   ├── summary.json
│   │   │   └── detailed_results.json
│   │   └── ...
│   └── ...
│   └── leaderboard.csv
```
- `summary.json` inside each strategy contains overall success/failure counts for each strategy
  - `model_name`: Model name e.g. "gpt-4"
  - `strategy_name`: Strategy name e.g. "cot"
  - `evaluation_date`: Evaluation date-time stamp for record keeping
  - `execution_accuracy`: % of problems that executed without errors
  - `solution_accuracy`: % of problems with correct solutions
  - `average_score`: Average of execution and solution accuracy
  - `satisfaction_execution_accuracy`: % of satisfaction problems that executed without errors
  - `satisfaction_solution_accuracy`: % of satisfaction problems with correct solutions
  - `optimization_execution_accuracy`: % of optimization problems that executed without errors
  - `optimization_solution_accuracy`:  of optimization problems with correct solutions
  - `problems_attempted`: Total number of problems attempted (number of problems in the dataset)
  - `problems_solved`: Total number of problems with correct solutions
  - `satisfaction_problems`: Number of satisfaction problems in the dataset
  - `optimization_problems`: Number of optimization problems in the dataset
- `detailed_results.json` inside each strategy contains
  - `problem_id`: Current problem id
  - `problem_type`: Problem type, either optimization or satisfaction
  - `execution_success`: If the problem executed correctly
  - `solution_success`: If the problem solution matches the ground truth
  - `timeout`: Timeout used for running the model
  - `solver`: Solver used for running the model
  - `output`: Output of the execution
- `leaderboard.csv`: Summary of all strategies and their corresponding metrics
