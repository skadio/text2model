import os
import time

import openai
from datasets import load_dataset
from tqdm import tqdm

from utils import API_CONFIG, call_openai_api, load_file, prepare_problem_data


def create_kg_prompt(problem):
    """Create a knowledge graph generation prompt using problem data"""
    problem_data = prepare_problem_data(problem)

    # Load the KG generation prompt template
    kg_prompt_template = load_file('prompts/kg_generation_prompt.txt')

    # Format the prompt with problem data
    kg_prompt = kg_prompt_template.format(
        problem_description=problem_data['description'],
        data_nomenclature=problem_data['data_nomenclature']
    )

    return kg_prompt


def save_kg_solution(output_dir, problem_id, solution):
    """Save the generated knowledge graph solution to a TTL file"""
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{problem_id}.ttl")
    with open(output_path, 'w') as f:
        f.write(solution)


def process_dataset(api_key, output_dir="knowledge_graphs"):
    """Process the entire dataset and generate knowledge graphs"""
    # Initialize OpenAI client
    client = openai.OpenAI(api_key=api_key)

    # Load dataset
    print("Loading dataset...")
    dataset = load_dataset("skadio/text2zinc")
    print(f"Loaded dataset with {len(dataset['train'])} examples")

    # Process each problem
    for idx, problem in enumerate(tqdm(dataset['train'])):
        try:
            prompt = create_kg_prompt(problem)

            solution = call_openai_api(client, prompt)

            # Save solution if successful
            if solution:
                save_kg_solution(output_dir, f"problem_{idx}", solution)
                print(f"Successfully processed problem {idx}")
            else:
                print(f"Failed to generate solution for problem {idx}")

            # Add delay to respect rate limits
            time.sleep(API_CONFIG['sleep_time'])

        except Exception as e:
            print(f"Error processing problem {idx}: {str(e)}")
            continue


def main():
    # Get API key from environment variable
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("Please set OPENAI_API_KEY environment variable")

    # Process the dataset
    process_dataset(api_key)


if __name__ == "__main__":
    main()
