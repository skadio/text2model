# Multi-Stage Modeling Process for MiniZinc Code Generation Using GPT-4

## Overview
This README describes the process of generating MiniZinc code from textual problem descriptions using OpenAI's GPT-4. The method follows a structured pipeline to generate intermediate code sections (parameters/variables, constraints, objective) before validating and assembling them into a final solution.

## Process Model
1. **Input Data:**
   - Provided in JSON (`input.json`) and DZN (`data.dzn`) formats.
   - Data nomenclature is generated from the JSON input and validated against the DZN data.

2. **Multi-Stage Prompt Structure:**
   - Each stage has a specific prompt for generating a distinct code section before proceeding to the next.

### Stages
1. **Parameter and Variable Generation:**
```plaintext
You are an expert MiniZinc developer.

Generate MiniZinc code for the Parameters and Variables from a given problem description with additional information about input data provided.

The MiniZinc code should assume that the data needed will be provided in a specific format through a .dzn file, so the generated code should assume the same names/data-types defined in the input data nomenclature and examples.

When generating the code, follow this format:

% Parameters

% Variables

**Problem Description:**
{problem_description}

**Input Data Nomenclature and Examples:**
{data_nomenclature}
```

2. **Constraint Generation:**
```plaintext
You are an expert MiniZinc developer.

Generate MiniZinc code for the Constraints from a given problem description with additional information about the parameters provided.

Given the Parameters and Variables part of the code, generate only the constraints.

When generating the code, follow this format:

% Constraints

**Problem Description:**
{problem_description}

**Input Data Nomenclature and Examples:**
{data_nomenclature}

**Parameters and Variables:**
{parameters_and_variables}
```

3. **Objective Generation:**
```plaintext
You are an expert MiniZinc developer.

Generate MiniZinc code for the Objective from a given problem description with additional information about the parameters, variables, and constraints provided.

Given the Parameters, Variables, and Constraints sections of the code, generate only the objective.

When generating the code, follow this format:

% Objective

**Problem Description:**
{problem_description}

**Input Data Nomenclature and Examples:**
{data_nomenclature}

**Parameters and Variables:**
{parameters_and_variables}

**Constraints:**
{constraints}
```

4. **Final Code Stitching:**
```plaintext
You are an expert MiniZinc developer.

Given the Parameters, Variables, Constraints, and Objective sections of the code, stitch them into a complete solution for the optimization problem.

When stitching the code, follow this format:

% Parameters

% Variables

% Constraints

% Objective

**Problem Description:**
{problem_description}

**Input Data Nomenclature and Examples:**
{data_nomenclature}

**Parameters and Variables:**
{parameters_and_variables}

**Constraints:**
{constraints}

**Objective:**
{objective}
```

5. **Validation and Correction:**
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

6. **Output:**
   - MiniZinc solutions `.mzn` files for each problem in [{skadio/text2zinc}](https://huggingface.co/datasets/{skadio/text2zinc}).
