# Text2Zinc Dataset Editor

A [flet](https://flet.dev) GUI for browsing, editing, and validating rows of a
Text2Zinc dataset (`input.json`, `data.dzn`, `model.mzn`, `output.json`,
`is_verified`). Launched via `text2model --editor`.

## Launch

```bash
text2model --editor
```

By default the editor opens, in order: a previous editing session (`text2zinc_edited.csv` in the current directory), otherwise the dataset bundled with the package. Use the **"Load from HuggingFace"** button inside the editor to instead start from a fresh copy of `skadio/text2zinc`, or open any other local dataset with **"Open CSV..."** — or non-interactively:

```bash
text2model --editor --text2zinc-path my_dataset.csv
```

## Save and Benchmark

- **Save** (or Ctrl+S) quick-saves your edits to `text2zinc_edited.csv` in the current directory.
- **Save As New Dataset...** exports to any path you choose. That path is a complete Text2Zinc dataset you can pass to `--text2zinc-path` to generate or benchmark against your edits instead of the default HuggingFace dataset:

```bash
text2model --strategies cot --model gpt-4 --output-dir my_results --text2zinc-path my_dataset.csv
python evals/evaluate.py --output-dir my_results --text2zinc-path my_dataset.csv
```

## Files

- **`app.py`** — Entry point and UI wiring. Builds the page layout (tabs,
  sidebar, navigation, chat panel), holds all `on_click`/`on_change`
  callbacks, and drives dataset load/save flow (local CSV, HuggingFace, HF
  mode). Edit this for: layout changes, new buttons/fields, new tabs,
  keyboard shortcuts, or changes to how/where datasets are loaded and saved.

- **`dataset_editor.py`** — `Text2ZincEditor`: framework-agnostic dataset
  logic with no flet dependency. Loading/saving CSVs, loading from
  HuggingFace, tracking the current item, and running MiniZinc
  (`execute_minizinc`). Also home to `blank_problem()` (schema for a new row)
  and `validate_item()` (required-fields check before export). Edit this for:
  CSV/HF I/O, MiniZinc execution behavior, or what counts as a "valid"
  problem.

- **`json_viewer.py`** — `create_json_viewer()`: renders an `input.json` dict
  as read-only flet widgets (metadata, description, parameters, output) for
  the non-edit view of the Input tab. Edit this for: how problem JSON is
  displayed when not in edit mode.

- **`chat_assistant.py`** — `ChatAssistant`: OpenAI-backed chat helper used by
  the "AI Assistant" panel. Builds a context-aware system prompt from the
  current problem, holds conversation history, and calls the OpenAI API.
  Edit this for: chat behavior, prompt content, or model handling.


## Adding a feature

- New UI control or tab → `app.py`.
- New dataset operation (e.g. a different import/export format) →
  `dataset_editor.py`, then wire it up from `app.py`.
- Change to how the read-only JSON view looks → `json_viewer.py`.
- Change to chat/AI behavior → `chat_assistant.py`.
