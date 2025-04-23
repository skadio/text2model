Baseline Modeling Process for MiniZinc Code Generation Using GPT-4

## Overview
This README describes the process of generating MiniZinc code from textual problem descriptions using OpenAI's GPT-4. The method involves structuring input data, creating a specialized prompt, and using GPT-4 to produce MiniZinc solutions.

## Process Model
1. **Input Data:**
   - Provided in JSON and DZN formats.

2. **Prompt Structure:**
   - The prompt includes a problem description and input data nomenclature.

### Example Prompt
```plaintext
You are an expert MiniZinc developer.

Generate MiniZinc code from a given problem description with additional information about the parameters provided.

The MiniZinc code should assume that the data needed will be provided in a specific format through a .dzn file, so the generated code should assume the same names defined in the input data nomenclature.

Please do not generate any other token, except the MiniZinc code.

Problem Description:
{description}

Input Data Nomenclature:
{data_nomenclature}
```

3. **Output:**
   - MiniZinc solutions `.mzn` files for each problem in [{skadio/text2zinc}](https://huggingface.co/datasets/{skadio/text2zinc})