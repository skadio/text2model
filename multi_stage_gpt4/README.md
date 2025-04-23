# Multi-Stage Modeling Process for MiniZinc Code Generation Using GPT-4

## Overview
This README describes the process of generating MiniZinc code from textual problem descriptions using OpenAI's GPT-4. The method involves generating intermediate code sections (parameters/variables, constraints, objective) before combining them into a final solution.

## Process Model
1. **Input Data:**
   - Provided in JSON and DZN formats.
   - Data nomenclature is generated from the JSON input and DZN data.

2. **Multi-Stage Prompt Structure:**
   - Each stage has a specific prompt for generating a distinct code section.

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

5. **Output:**
   - MiniZinc solutions `.mzn` files for each problem in [{skadio/text2zinc}](https://huggingface.co/datasets/{skadio/text2zinc}).