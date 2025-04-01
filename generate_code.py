import os
from datasets import load_dataset
import openai
from tqdm import tqdm
import time
import ast
import re


def parse_dzn_string(dzn_str):
    """Parse dzn string into parameter-value pairs"""
    # Get parameter names
    parameters = re.findall(r'(\w+)\s*=\s*[^;]+;', dzn_str)
    # Split content into lines
    content_list = dzn_str.split("\n")
    # Filter out empty lines and create parameter-value pairs
    valid_lines = [line for line in content_list if '=' in line]
    # Create list of tuples with (parameter_name, full_line)
    result = list(zip(parameters, valid_lines))
    return result


def create_prompt(problem):
    """Create a prompt for GPT-4 using the problem data"""
    input_data = ast.literal_eval(problem['input.json'])
    description = input_data['description']
    parameters = input_data['parameters']

    # Parse the dzn string
    dzn_data = parse_dzn_string(problem['data.dzn'])

    # Create data nomenclature section
    data_nomenclature = []
    for idx, param in enumerate(parameters):
        symbol = param['symbol']
        definition = param['definition']
        shape = param['shape']

        # Find the corresponding dzn line for this parameter
        example_line = next(
            (line for param_name, line in dzn_data if param_name == symbol),
            f"{symbol} = N/A;")

        # Format shape display
        shape_display = f"[{', '.join(map(str, shape))}]" if shape else "scalar"

        data_nomenclature.append(f"{idx + 1}. {symbol}: {definition}\n"
                                 f"Example: {example_line}\n"
                                 f"Shape: {shape_display}")

    prompt = f"""You are an expert MiniZinc developer.

Generate Minizinc code from a given problem description with additional information about the parameters provided.

The MiniZinc code should assume that the data needed, will be provided in a specific format through a .dzn file, so the generated code should assume the same names defined in the input data nomenclature.

Please do not generate any other token, except the MiniZinc code.

Problem Description:
{description}

Input Data Nomenclature:
{chr(10).join(data_nomenclature)}
"""
    return prompt


def extract_code_blocks(text):
    # Regex pattern to match code blocks with optional language specifier
    pattern = re.compile(r'```(?:\w+)?\n(.*?)\n```', re.DOTALL)
    # Find all matches in the text
    matches = pattern.findall(text)
    try:
        return matches[0]
    except:
        return text


def call_gpt4(client, prompt):
    """Call GPT-4 API with the given prompt"""
    try:
        completion = client.chat.completions.create(model="gpt-4",
                                                    messages=[{
                                                        "role": "user",
                                                        "content": prompt
                                                    }],
                                                    temperature=0,
                                                    max_tokens=4096)
        result = completion.choices[0].message.content.strip()
        print(result)
        return extract_code_blocks(result)
    except Exception as e:
        print(f"Error calling GPT-4 API: {str(e)}")
        return None


def save_solution(output_dir, problem_id, solution):
    """Save the generated solution to a file"""
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{problem_id}.mzn")
    with open(output_path, 'w') as f:
        f.write(solution)


def process_dataset(api_key, output_dir="solutions"):
    """Process the entire dataset and generate solutions"""
    # Initialize OpenAI client
    client = openai.OpenAI(api_key=api_key)

    # Load dataset
    print("Loading dataset...")
    dataset = load_dataset("skadio/text2zinc")
    print(f"Loaded dataset with {len(dataset['train'])} examples")

    # Process each problem
    for idx, problem in enumerate(tqdm(dataset['train'])):
        try:
            # Create prompt
            prompt = create_prompt(problem)

            # Get solution from GPT-4
            solution = call_gpt4(client, prompt)

            # Save solution if successful
            if solution:
                save_solution(output_dir, f"problem_{idx}", solution)

            # Add small delay to respect rate limits
            time.sleep(5)

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
