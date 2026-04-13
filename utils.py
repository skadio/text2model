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


def extract_global_constraint(text):
    first_line = text.splitlines()[0]
    return re.findall(r'`(.*?)`', first_line)[0]


def call_api(client, model: str, prompt: str) -> Optional[str]:
    if model in ["gpt-4", "gpt-4o", "gpt-5.2"]:
        solution = call_openai_api(client, prompt)
        print(solution)
        return solution
    else:
        solution = call_ollama_api(client, prompt)
        return solution


def call_openai_api(client: openai.OpenAI, prompt: str) -> Optional[str]:
    """Call OpenAI API with the given prompt"""
    try:
        # Map model names - use o3 for gpt-4o, gpt-5.2 uses its own name
        model_name = API_CONFIG['model']
        if model_name == 'gpt-4o':
            model_name = 'o3-2025-04-16'
        # gpt-5.2 uses its own name directly

        params = {
            "model": model_name,
            "messages": [{"role": "user", "content": prompt}]
        }

        # Add temperature and max_tokens only for non-reasoning models
        # Reasoning models: gpt-4o (mapped to o3), gpt-5.2
        if API_CONFIG['model'] not in ['gpt-4o', 'gpt-5.2']:
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
        
        # Build command - only include dzn if it has content
        if dzn_data and dzn_data.strip():
            with open(temp_dzn_path, 'w') as f:
                f.write(dzn_data)
            cmd = ["/snap/bin/minizinc", temp_file_path, temp_dzn_path]
        else:
            cmd = ["/snap/bin/minizinc", temp_file_path]
        
        # Run MiniZinc to check for syntax errors
        result = subprocess.run(
            cmd,
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
    """Create data nomenclature section for prompts.
    
    Returns empty string if no parameters or no dzn_data.
    """
    # Handle empty dzn_data
    if not dzn_data:
        return ""
    
    parameters = input_data.get('parameters', [])
    
    # Handle empty parameters
    if not parameters:
        return ""
    
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
    
    # Handle missing or empty dzn data
    if problem.get('data.dzn') and problem['data.dzn'].strip():
        dzn_data = parse_dzn_string(problem['data.dzn'])
    else:
        dzn_data = []
    
    data_nomenclature = create_data_nomenclature(input_data, dzn_data)

    return {
        'description': input_data['description'],
        'data_nomenclature': data_nomenclature,
        'objective_type': input_data.get('metadata', {}).get('objective', 'unknown'),
        'identifier': input_data.get('metadata', {}).get('identifier', ''),
        'input_data': input_data,
        'dzn_data': dzn_data
    }


def get_effective_input_data(problem_data: Dict[str, Any]) -> str:
    """Get the input data, with instructions if no dzn data exists.
    
    When there's no separate dzn data, returns instructions clarifying that:
    1. All data is in the problem description
    2. Only MiniZinc code should be generated (not CPOPT or other formats)
    
    Args:
        problem_data: The dict returned by prepare_problem_data()
    
    Returns:
        The original data_nomenclature, or instruction text if empty
    """
    if not problem_data['data_nomenclature'].strip():
        return """IMPORTANT: All data and parameters are already included in the problem description above. 
You must embed all data directly in the MiniZinc model - do not expect external .dzn files or assume data will be provided separately.
Generate MiniZinc code ONLY. Do NOT generate CPOPT, COPT, or any other format even if the problem description mentions it."""
    
    return problem_data['data_nomenclature']


def create_baseline_prompt(problem: Dict[str, Any]) -> str:
    """Create a baseline prompt for single-stage generation"""
    problem_data = prepare_problem_data(problem)
    effective_input_data = get_effective_input_data(problem_data)
    
    # Check if we have dzn data or not
    if problem_data['data_nomenclature'].strip():
        # Original prompt for problems with dzn data
        return f"""You are an expert MiniZinc developer.

Generate Minizinc code from a given problem description with additional information about the parameters provided.

The MiniZinc code should assume that the data needed, will be provided in a specific format through a .dzn file, so the generated code should assume the same names defined in the input data nomenclature.

Please do not generate any other token, except the MiniZinc code.

Problem Description:
{problem_data['description']}

Input Data Nomenclature:
{effective_input_data}
"""
    else:
        # Modified prompt for problems without dzn data (like cardinal_operations)
        return f"""You are an expert MiniZinc developer.

Generate MiniZinc code from the given problem description. All data and parameters are included in the problem description, so embed them directly in your MiniZinc model.

IMPORTANT: Generate MiniZinc code ONLY. Do NOT generate CPOPT, COPT, or any other format even if the problem description asks for it.

Please do not generate any other token, except the MiniZinc code.

Problem Description:
{problem_data['description']}
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


def get_problem_source(problem):
    """Extract the source from problem's input.json metadata"""
    try:
        input_data = ast.literal_eval(problem['input.json'])
        return input_data.get('metadata', {}).get('source', None)
    except Exception:
        return None


def get_problem_identifier(problem, idx):
    """
    Extract the identifier from problem's input.json metadata.
    If identifier is empty or missing, generate one based on source and index.
    """
    try:
        input_data = ast.literal_eval(problem['input.json'])
        metadata = input_data.get('metadata', {})
        identifier = metadata.get('identifier', '')
        
        # Check if identifier is empty or just whitespace
        if not identifier or not identifier.strip():
            # Generate identifier from source and index
            source = metadata.get('source', 'unknown')
            # Clean up source to make it filename-safe
            safe_source = re.sub(r'[^\w\-]', '_', source.lower())
            identifier = f"{safe_source}_problem_{idx}"
        elif identifier in ['easy_lp', 'complex_lp']:
            # Append index to these non-unique identifiers
            identifier = f"{identifier}_{idx}"
        
        return identifier
    except Exception:
        return f"unknown_problem_{idx}"


def get_cardinal_ops_subfolder(problem):
    """
    Determine the subfolder name for cardinal_operations datasets.
    Returns: 'easylp', 'complexlp', 'nl4opt', 'industryor', or None if not a cardinal_operations source.
    """
    try:
        input_data = ast.literal_eval(problem['input.json'])
        metadata = input_data.get('metadata', {})
        source = metadata.get('source', '')
        identifier = metadata.get('identifier', '')
        
        if not source.startswith('cardinal_operations'):
            return None
        
        # Determine subfolder based on source
        if source == 'cardinal_operations_mamo':
            # For mamo, use the identifier (easy_lp or complex_lp)
            if identifier == 'easy_lp':
                return 'easylp'
            elif identifier == 'complex_lp':
                return 'complexlp'
            else:
                return 'mamo'  # fallback
        elif source == 'cardinal_operations_nl4opt':
            return 'nl4opt'
        elif source == 'cardinal_operations_industryor':
            return 'industryor'
        else:
            # Extract suffix from source name
            suffix = source.replace('cardinal_operations_', '')
            return suffix if suffix else None
            
    except Exception:
        return None


def filter_dataset_by_source(dataset, source_filter):
    """Filter dataset by source field in metadata"""
    def matches_source(problem):
        source = get_problem_source(problem)
        if source is None:
            return False
        # Support partial matching (case-insensitive)
        return source_filter.lower() in source.lower()
    
    return dataset.filter(matches_source)


def get_available_sources(dataset):
    """Get all unique sources in the dataset"""
    sources = set()
    for problem in dataset:
        source = get_problem_source(problem)
        if source:
            sources.add(source)
    return sorted(sources)