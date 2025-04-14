import os
from datasets import load_dataset
import openai
from tqdm import tqdm
import time
import ast
import re


def extract_code_blocks(text):
    pattern = re.compile(r'```(?:\w+)?\n(.*?)\n```', re.DOTALL)
    matches = pattern.findall(text)
    return matches[0] if matches else text


def call_gpt4(client, prompt):
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


def load_prompt(file_path):
    with open(file_path, 'r') as file:
        return file.read()


def generate_section(client, prompt_template, **kwargs):
    prompt = prompt_template.format(**kwargs)
    return call_gpt4(client, prompt)


def save_solution(output_dir, problem_id, solution):
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{problem_id}.mzn")
    with open(output_path, 'w') as f:
        f.write(solution)


def parse_dzn_string(dzn_str):
    parameters = re.findall(r'(\w+)\\s*=\\s*[^;]+;', dzn_str)
    content_list = dzn_str.split("\\n")
    valid_lines = [line for line in content_list if '=' in line]
    result = list(zip(parameters, valid_lines))
    return result


def create_data_nomenclature(input_data, dzn_data):
    parameters = input_data['parameters']
    data_nomenclature = []
    for idx, param in enumerate(parameters):
        symbol = param['symbol']
        definition = param['definition']
        shape = param['shape']
        example_line = next(
            (line for param_name, line in dzn_data if param_name == symbol),
            f"{symbol} = N/A;")
        shape_display = f"[{', '.join(map(str, shape))}]" if shape else "scalar"
        data_nomenclature.append(f"{idx + 1}. {symbol}: {definition}\\n"
                                 f"Example: {example_line}\\n"
                                 f"Shape: {shape_display}")
    return '\n'.join(data_nomenclature)


def process_dataset(api_key, output_dir="solutions_stitch_v2"):
    client = openai.OpenAI(api_key=api_key)
    dataset = load_dataset("skadio/text2zinc")

    param_prompt = load_prompt('parameter_and_varaible_generation_prompt.txt')
    constraint_prompt = load_prompt('constraint_generation_prompt.txt')
    objective_prompt = load_prompt('objective_generation_prompt.txt')
    code_prompt = load_prompt('code_generation_prompt.txt')
    validation_prompt = load_prompt('validation_prompt.txt')

    for idx, problem in enumerate(tqdm(dataset['train'])):
        try:
            input_data = ast.literal_eval(problem['input.json'])
            description = input_data['description']
            dzn_data = parse_dzn_string(problem['data.dzn'])
            data_nomenclature = create_data_nomenclature(input_data, dzn_data)

            parameters_and_variables = generate_section(
                client,
                param_prompt,
                problem_description=description,
                data_nomenclature=data_nomenclature)
            if not parameters_and_variables:
                continue

            time.sleep(2)
            constraints = generate_section(
                client,
                constraint_prompt,
                problem_description=description,
                data_nomenclature=data_nomenclature,
                parameters_and_variables=parameters_and_variables)
            if not constraints:
                continue

            time.sleep(2)
            objective = generate_section(
                client,
                objective_prompt,
                problem_description=description,
                data_nomenclature=data_nomenclature,
                parameters_and_variables=parameters_and_variables,
                constraints=constraints)
            if not objective:
                continue

            time.sleep(2)
            final_code = generate_section(
                client,
                code_prompt,
                problem_description=description,
                data_nomenclature=data_nomenclature,
                parameters_and_variables=parameters_and_variables,
                constraints=constraints,
                objective=objective)
            if not final_code:
                continue

            time.sleep(2)
            validated_code = generate_section(
                client,
                validation_prompt,
                problem_description=description,
                data_nomenclature=data_nomenclature,
                objective_type=input_data["metadata"]["objective"],
                final_code=final_code)
            if validated_code:
                save_solution(output_dir, f"problem_{idx}", validated_code)

            time.sleep(3)

        except Exception as e:
            print(f"Error processing problem {idx}: {str(e)}")
            continue


def main():
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("Please set OPENAI_API_KEY environment variable")
    process_dataset(api_key)


if __name__ == "__main__":
    main()
