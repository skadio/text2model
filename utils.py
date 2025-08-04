import ast
import os
import re
import subprocess
from typing import Any, Dict, List, Optional, Tuple

import openai
from langchain_ollama import ChatOllama

# Global OpenAI API configuration
API_CONFIG = {
    'model': 'gpt-4',
    'temperature': 0,
    'max_tokens': 4096,
    'sleep_time': 3
}


def extract_code_blocks(text: str) -> str:
    """Extract code blocks from markdown-formatted text"""
    pattern = re.compile(r'```(?:\w+)?\n(.*?)\n```', re.DOTALL)
    matches = pattern.findall(text)
    return matches[0] if matches else text


def call_api(client, model: str, prompt: str) -> Optional[str]:
    if model in ["gpt-4","gpt-4o","o3-mini","gpt-4o-mini"]:
        solution = call_openai_api(client, prompt)
        return solution
    else:
        solution = call_ollama_api(client, prompt)
        return solution


def call_openai_api(client: openai.OpenAI, prompt: str) -> Optional[str]:
    """Call OpenAI API with the given prompt"""
    try:
        # Map model names - use o3 for gpt-4o
        model_name = API_CONFIG['model']
        if model_name == 'gpt-4o':
            model_name = 'o3-2025-04-16'

        params = {
            "model": model_name,
            "messages": [{"role": "user", "content": prompt}]
        }

        # Add temperature and max_tokens only for non-reasoning models
        if API_CONFIG['model'] != 'gpt-4o':
            params["temperature"] = API_CONFIG['temperature']
            params["max_tokens"] = API_CONFIG['max_tokens']

        completion = client.chat.completions.create(**params)
        result = completion.choices[0].message.content.strip()
        return extract_code_blocks(result)
    except Exception as e:
        print(f"Error calling OpenAI API: {e}")
        return None
        

def call_ollama_api(client: ChatOllama, prompt: str) -> Optional[str]:
    """Call ChatOllama with the given prompt"""
    try:
        messages = [
            {"role": "user", "content": prompt},
        ]
        result = client.invoke(messages).content.strip()
        return extract_code_blocks(result)
    except Exception as e:
        print(f"Error calling ChatOllama: {e}")
        return None


def check_syntax(mzn_code: str, dzn_data: str, timeout: int = 60) -> Optional[str]:
    """Check MiniZinc syntax and return error message if any"""
    temp_file_path = "temp_model.mzn"
    temp_dzn_path = "temp_data.dzn"

    try:
        # Save temporary MiniZinc file
        with open(temp_file_path, 'w') as f:
            f.write(mzn_code)

        # Save dzn data
        with open(temp_dzn_path, 'w') as f:
            f.write(dzn_data)

        # Run MiniZinc to check for syntax errors
        result = subprocess.run(
            ["/snap/bin/minizinc", temp_file_path, temp_dzn_path],
            capture_output=True,
            text=True,
            timeout=timeout
        )

        # Clean up temporary files
        if os.path.exists(temp_file_path):
            os.remove(temp_file_path)
        if os.path.exists(temp_dzn_path):
            os.remove(temp_dzn_path)

        if result.returncode != 0:
            return result.stderr
        return None

    except subprocess.TimeoutExpired:
        # Clean up on timeout
        if os.path.exists(temp_file_path):
            os.remove(temp_file_path)
        if os.path.exists(temp_dzn_path):
            os.remove(temp_dzn_path)
        return f"MiniZinc execution timed out after {timeout} seconds"
    except Exception as e:
        # Clean up on any other error
        if os.path.exists(temp_file_path):
            os.remove(temp_file_path)
        if os.path.exists(temp_dzn_path):
            os.remove(temp_dzn_path)
        return f"Error checking syntax: {str(e)}"


def parse_dzn_string(dzn_str: str) -> List[Tuple[str, str]]:
    """Parse dzn string into parameter-value pairs"""
    parameters = re.findall(r'(\w+)\s*=\s*[^;]+;', dzn_str)
    content_list = dzn_str.split("\n")
    valid_lines = [line for line in content_list if '=' in line]
    result = list(zip(parameters, valid_lines))
    return result


def create_data_nomenclature(input_data: Dict[str, Any], dzn_data: List[Tuple[str, str]]) -> str:
    """Create data nomenclature section for prompts"""
    parameters = input_data['parameters']
    data_nomenclature = []

    for idx, param in enumerate(parameters):
        symbol = param['symbol']
        definition = param['definition']
        shape = param['shape']

        # Find the corresponding dzn line for this parameter
        example_line = next(
            (line for param_name, line in dzn_data if param_name == symbol),
            f"{symbol} = N/A;"
        )

        # Format shape display
        shape_display = f"[{', '.join(map(str, shape))}]" if shape else "scalar"

        data_nomenclature.append(
            f"{idx + 1}. {symbol}: {definition}\n"
            f"Example: {example_line}\n"
            f"Shape: {shape_display}"
        )

    return '\n'.join(data_nomenclature)


def prepare_problem_data(problem: Dict[str, Any]) -> Dict[str, Any]:
    """Prepare problem data for use in prompts"""
    input_data = ast.literal_eval(problem['input.json'])
    if problem['data.dzn']:
        dzn_data = parse_dzn_string(problem['data.dzn'])
    else:
        dzn_data = ""
    data_nomenclature = create_data_nomenclature(input_data, dzn_data)

    return {
        'description': input_data['description'],
        'data_nomenclature': data_nomenclature,
        'objective_type': input_data['metadata']['objective'],
        'identifier': input_data['metadata']['identifier'],
        'input_data': input_data,
        'dzn_data': dzn_data
    }


def create_baseline_prompt(problem: Dict[str, Any]) -> str:
    """Create a baseline prompt for single-stage generation"""
    problem_data = prepare_problem_data(problem)

    return f"""You are an expert MiniZinc developer.

Generate Minizinc code from a given problem description with additional information about the parameters provided.

The MiniZinc code should assume that the data needed, will be provided in a specific format through a .dzn file, so the generated code should assume the same names defined in the input data nomenclature.

Please do not generate any other token, except the MiniZinc code.

Problem Description:
{problem_data['description']}

Input Data Nomenclature:
{problem_data['data_nomenclature']}
"""


def save_solution(output_dir: str, problem_id: str, solution: str) -> None:
    """Save the generated solution to a file"""
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, f"{problem_id}.mzn")
    with open(output_path, 'w') as f:
        f.write(solution)


def load_file(file_path: str) -> str:
    """Load a prompt template from file"""
    try:
        with open(file_path, 'r') as file:
            return file.read()
    except FileNotFoundError:
        print(f"Prompt file not found: {file_path}")
        return ""
