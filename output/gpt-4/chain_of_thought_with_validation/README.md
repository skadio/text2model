# Chain-of-Thought + Validation Modeling Process for MiniZinc Code Generation Using GPT-4

## Overview
This README describes the process of generating MiniZinc code from textual problem descriptions using OpenAI's GPT-4. This approach follows a two-step pipeline: generating the complete MiniZinc code using a Chain-of-Thought (CoT) prompt and then validating and correcting it using a validation prompt.

## Process Model
1. **Input Data:**
   - Provided in JSON (`input.json`) and DZN (`data.dzn`) formats.
   - Data nomenclature is generated from the JSON input and validated against the DZN data.

2. **Two-Stage Prompt Structure:**
   - The first stage generates the complete MiniZinc code.
   - The second stage validates the MiniZinc code and ensures correctness.

### Stages
1. **Code Generation using Chain-of-Thought Prompt:**
```plaintext
You are an expert MiniZinc developer.

Generate MiniZinc code from a given problem description with additional information about the parameters provided.

The MiniZinc code should assume that the data needed will be provided in a specific format through a .dzn file, so the generated code should assume the same names/data-types defined in the input data nomenclature and examples.

When generating the code, follow this format:

% Parameters

% Variables

% Constraints

% Objective

**Problem Description:**
{problem_description}

**Input Data Nomenclature and Examples:**
{data_nomenclature}
```

2. **Validation and Correction:**
```plaintext
You are an expert MiniZinc developer.

Review the generated MiniZinc code to ensure correctness and alignment with the problem description, input parameters, and objective type.

**Problem Description:**  
{problem_description}

**Input Data Nomenclature and Examples:**  
{data_nomenclature}

**Objective Type:**  
{objective_type}

**Generated MiniZinc Code:**  
`minizinc
{final_code}
`

### **Validation Checklist**
1. Ensure all parameters and variable names in `data.dzn` match the generated MiniZinc code.
2. Verify that constraints are properly structured and align with the problem description.
3. Check the objective function to confirm it is correctly set as:
   - `minimize` if `{objective_type}` is "minimization".
   - `maximize` if `{objective_type}` is "maximization".
   - `satisfy` if `{objective_type}` is "satisfaction".
4. Ensure no syntax errors exist in the generated MiniZinc code.
5. Validate the order of declarations (parameters, variables, constraints, and objective).
6. Identify any missing components or inconsistencies.

If any issues are found, revise the MiniZinc code accordingly. Output only the corrected MiniZinc code.
```

3. **Output:**
   - MiniZinc solutions `.mzn` files for each problem in [{skadio/text2zinc}](https://huggingface.co/datasets/{skadio/text2zinc}).