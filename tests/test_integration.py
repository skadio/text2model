"""Opt-in tests that hit real external dependencies.

These are NOT run in CI (see .github/workflows/tests.yml, which passes
`-m "not integration"`) and are skipped automatically whenever the
dependency they need isn't available locally:

- MiniZinc tests need the `minizinc` executable on PATH.
- OpenAI tests need OPENAI_API_KEY in the environment.
- Hugging Face tests need HF_TOKEN in the environment, plus torch/unsloth
  and a GPU installed locally (they are not part of the base install).

Run everything (offline + integration) locally with:
    pytest -m ""

Run only the integration subset with:
    pytest -m integration
"""
import csv
import json
import os
import shutil
import sys
from pathlib import Path
from unittest.mock import MagicMock

import pytest

from text2model import copilots, huggingface, main, utils
from text2model.editor import app as editor_app

pytestmark = pytest.mark.integration

requires_minizinc = pytest.mark.skipif(
    shutil.which("minizinc") is None,
    reason="minizinc executable not found on PATH",
)

requires_openai_key = pytest.mark.skipif(
    not os.getenv("OPENAI_API_KEY"),
    reason="OPENAI_API_KEY not set in the environment",
)


def _unsloth_available() -> bool:
    try:
        import unsloth  # noqa: F401
    except Exception:
        return False
    return True


def _hf_token_available() -> bool:
    if os.getenv("HF_TOKEN") or os.getenv("HUGGING_FACE_HUB_TOKEN"):
        return True
    from huggingface_hub import get_token

    return bool(get_token())


requires_hf_token = pytest.mark.skipif(
    not _hf_token_available(),
    reason="No HF token found (set HF_TOKEN/HUGGING_FACE_HUB_TOKEN or run `huggingface-cli login`)",
)

requires_unsloth = pytest.mark.skipif(
    not _unsloth_available(),
    reason="unsloth (torch + a CUDA GPU) not available in this environment",
)

# Smallest checkpoint in HUGGINGFACE_MODELS: keeps the real load+generate
# test's download/inference time reasonable. Not exhaustive over every
# fine-tuned model for the same reason the OpenAI test isn't exhaustive.
HF_TEST_MODEL = "learn2zinc-qwen3-0.6b"

# Same problem description used across every "generate real MiniZinc code from
# a description" test below, so results are directly comparable model-to-model
# and backend-to-backend instead of each test inventing its own.
PROBLEM_DESCRIPTION = (
    "A country produces fighter jets each year. Some of these jets must be "
    "set aside for pilot training instead of combat use. Year 1 production "
    "is 10 jets, and Year 2 production is 15 jets. Each training jet can "
    "train 5 pilots per year. Training runs for 2 years, starting in Year "
    "1. Determine how many pilots will be trained in total by the end of "
    "Year 2."
)

# Every real strategy ('all' is just a --strategies expansion, not a strategy
# of its own).
ALL_REAL_STRATEGIES = [s for s in main.AVAILABLE_STRATEGIES if s != "all"]


def _write_tiny_dataset_csv(tmp_path, rows=None):
    """Write a minimal local Text2Zinc CSV (the 5 columns `load_text2zinc_dataset`
    reads) and return its path. Default fixture: 3 rows across 2 sources, mixed
    is_verified, so tests can exercise --source / --full-dataset / --list-*
    filtering without touching the real HuggingFace dataset."""
    if rows is None:
        rows = [
            {"identifier": "csplib_p0", "source": "csplib", "is_verified": True},
            {"identifier": "nlp4lp_p1", "source": "nlp4lp", "is_verified": False},
            {"identifier": "nlp4lp_p2", "source": "nlp4lp", "is_verified": True},
        ]

    csv_path = tmp_path / "tiny_dataset.csv"
    with open(csv_path, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(
            f, fieldnames=["input.json", "data.dzn", "model.mzn", "output.json", "is_verified"]
        )
        writer.writeheader()
        for row in rows:
            input_data = {
                "description": f"Problem description for {row['identifier']}.",
                "parameters": [],
                "metadata": {
                    "objective": "unknown",
                    "identifier": row["identifier"],
                    "source": row["source"],
                },
            }
            writer.writerow({
                "input.json": repr(input_data),
                "data.dzn": "",
                "model.mzn": "",
                "output.json": "{}",
                "is_verified": str(row["is_verified"]),
            })
    return csv_path


# ── CLI wiring & dataset loading: no API key, network, or minizinc needed ───
# (Kept in this file — not tests/test_main.py or tests/test_utils.py — purely
# so they stay out of CI, per the "don't touch what CI runs" ask; these are
# local-only checks for README examples that were previously untested.)

def test_resolve_problem_ids_by_index():
    dataset = [
        {"input.json": repr({"metadata": {"identifier": "a"}})},
        {"input.json": repr({"metadata": {"identifier": "b"}})},
    ]
    assert utils.resolve_problem_ids(dataset, ["1"]) == [(1, dataset[1])]


def test_resolve_problem_ids_by_identifier():
    dataset = [
        {"input.json": repr({"metadata": {"identifier": "a"}})},
        {"input.json": repr({"metadata": {"identifier": "b"}})},
    ]
    assert utils.resolve_problem_ids(dataset, ["b"]) == [(1, dataset[1])]


def test_resolve_problem_ids_skips_out_of_range_index(capsys):
    dataset = [{"input.json": repr({"metadata": {"identifier": "a"}})}]
    assert utils.resolve_problem_ids(dataset, ["5"]) == []
    assert "out of range" in capsys.readouterr().out


def test_resolve_problem_ids_skips_unknown_identifier(capsys):
    dataset = [{"input.json": repr({"metadata": {"identifier": "a"}})}]
    assert utils.resolve_problem_ids(dataset, ["nonexistent"]) == []
    assert "Unknown problem id" in capsys.readouterr().out


def test_resolve_problem_ids_duplicate_identifiers_resolve_to_first():
    dataset = [
        {"input.json": repr({"metadata": {"identifier": "dup"}})},
        {"input.json": repr({"metadata": {"identifier": "dup"}})},
    ]
    assert utils.resolve_problem_ids(dataset, ["dup"]) == [(0, dataset[0])]


def test_load_text2zinc_dataset_local_csv_parses_rows(tmp_path):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    dataset = utils.load_text2zinc_dataset(str(csv_path))

    assert len(dataset) == 3
    assert dataset[0]["is_verified"] is True
    assert dataset[1]["is_verified"] is False
    assert utils.get_problem_source(dataset[0]) == "csplib"
    assert utils.get_problem_identifier(dataset[0], 0) == "csplib_p0"


def test_list_sources_reports_counts_across_full_dataset(tmp_path, monkeypatch, capsys):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    monkeypatch.setattr(sys, "argv", [
        "text2model", "--list-sources", "--dataset-path", str(csv_path),
    ])

    main.main()

    out = capsys.readouterr().out
    assert "csplib: 1 instances" in out
    assert "nlp4lp: 2 instances" in out


def test_list_problem_ids_default_excludes_unverified(tmp_path, monkeypatch, capsys):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    monkeypatch.setattr(sys, "argv", [
        "text2model", "--list-problem-ids", "--dataset-path", str(csv_path),
    ])

    main.main()

    out = capsys.readouterr().out
    assert "csplib_p0" in out
    assert "nlp4lp_p2" in out
    assert "nlp4lp_p1" not in out


def test_list_problem_ids_full_dataset_includes_unverified(tmp_path, monkeypatch, capsys):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    monkeypatch.setattr(sys, "argv", [
        "text2model", "--list-problem-ids", "--full-dataset", "--dataset-path", str(csv_path),
    ])

    main.main()

    assert "nlp4lp_p1" in capsys.readouterr().out


def test_list_problem_ids_filters_by_source(tmp_path, monkeypatch, capsys):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    monkeypatch.setattr(sys, "argv", [
        "text2model", "--list-problem-ids", "--full-dataset",
        "--source", "nlp4lp", "--dataset-path", str(csv_path),
    ])

    main.main()

    out = capsys.readouterr().out
    assert "csplib_p0" not in out
    assert "nlp4lp_p1" in out
    assert "nlp4lp_p2" in out


def test_strategies_all_dispatches_every_strategy(tmp_path, monkeypatch):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    output_dir = str(tmp_path / "output")

    def make_fake_strategy(name):
        def fake(client, model, problem, problem_identifier, out_dir):
            Path(out_dir, f"{problem_identifier}.mzn").write_text(f"% {name}")
            return True
        return fake

    fake_map = {name: make_fake_strategy(name) for name in copilots.STRATEGY_MAP}
    monkeypatch.setattr(main, "_STRATEGY_MAP", fake_map)
    monkeypatch.setattr(sys, "argv", [
        "text2model", "--model", "phi4", "--dataset-path", str(csv_path),
        "--problem-ids", "0", "--strategies", "all",
        "--output-dir", output_dir, "--sleep-time", "0",
    ])

    main.main()

    summary = json.loads((Path(output_dir) / "phi4" / "summary.json").read_text())
    for name in copilots.STRATEGY_MAP:
        assert summary[name]["success"] == 1
        assert summary[name]["failed"] == 0


def test_problem_mode_reads_description_from_file(tmp_path, monkeypatch, capsys):
    problem_file = tmp_path / "problem.txt"
    problem_file.write_text("A file-based problem description.")
    captured = {}

    def fake_init_client(args):
        return object()

    def fake_strategy(client, model, problem, problem_identifier, output_dir):
        captured["problem"] = problem
        Path(output_dir, "output.mzn").write_text("var int: x;")
        return True

    monkeypatch.setattr(main, "_init_client", fake_init_client)
    monkeypatch.setitem(main._STRATEGY_MAP, "cot", fake_strategy)
    monkeypatch.setattr(sys, "argv", [
        "text2model", "--problem", str(problem_file), "--strategies", "cot",
    ])

    main.main()

    problem_data = utils.prepare_problem_data(captured["problem"])
    assert problem_data["description"] == "A file-based problem description."
    assert capsys.readouterr().out.rstrip().endswith("var int: x;")


def test_editor_load_csv_parses_local_dataset(tmp_path):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    editor = editor_app.Text2ZincEditor()

    assert editor.load_csv(str(csv_path)) is True
    assert len(editor.data) == 3
    assert editor.data[0]["is_verified"] is True
    assert editor.data[1]["is_verified"] is False
    assert editor.data[0]["input.json"]["metadata"]["identifier"] == "csplib_p0"


def _fake_flet_app(target):
    """Stand-in for flet.app(target=...): calls target synchronously with a
    Mock page instead of opening a real window (headless-safe — main() only
    assigns page.X / calls page.add()/page.update(), never reads page state
    back, per direct inspection of text2model/editor/app.py)."""
    target(MagicMock())


def test_editor_cli_launches_without_error(monkeypatch):
    monkeypatch.setattr(editor_app.ft, "app", _fake_flet_app)
    monkeypatch.setattr(sys, "argv", ["text2model", "--editor"])

    main.main()  # must not raise


def test_editor_cli_launches_with_dataset_path_without_error(tmp_path, monkeypatch):
    csv_path = _write_tiny_dataset_csv(tmp_path)
    monkeypatch.setattr(editor_app.ft, "app", _fake_flet_app)
    monkeypatch.setattr(sys, "argv", ["text2model", "--editor", "--dataset-path", str(csv_path)])

    main.main()  # must not raise


# ── MiniZinc: real binary, no network ────────────────────────────────────────

@requires_minizinc
def test_check_syntax_accepts_valid_model():
    code = "var 1..10: x;\nconstraint x > 5;\nsolve satisfy;"
    assert utils.check_syntax(code, "") is None


@requires_minizinc
def test_check_syntax_rejects_invalid_model():
    code = "var int x;\nsolve satisfy"  # missing colon and semicolon
    error = utils.check_syntax(code, "")
    assert error


# ── OpenAI: one cheap, bounded call — not run exhaustively ──────────────────

@requires_openai_key
def test_call_openai_api_live_returns_text():
    import openai

    client = openai.OpenAI()
    original_config = dict(utils.API_CONFIG)
    utils.API_CONFIG.update({"model": "gpt-4o-mini", "temperature": 0, "max_tokens": 20})
    try:
        result = utils.call_openai_api(client, "Reply with exactly: OK")
    finally:
        utils.API_CONFIG.clear()
        utils.API_CONFIG.update(original_config)

    assert result


# ── Hugging Face: real local model load + generation, opt-in only ──────────

@requires_hf_token
@requires_unsloth
def test_load_huggingface_model_returns_model_and_tokenizer():
    model, tokenizer = huggingface.load_huggingface_model(HF_TEST_MODEL)
    assert model is not None
    assert tokenizer is not None
    # Loading is cached: a second call must return the exact same objects,
    # not reload the checkpoint.
    model_again, tokenizer_again = huggingface.load_huggingface_model(HF_TEST_MODEL)
    assert model_again is model
    assert tokenizer_again is tokenizer


@requires_hf_token
@requires_unsloth
def test_call_huggingface_api_live_returns_code():
    client = huggingface.load_huggingface_model(HF_TEST_MODEL)
    problem = utils.create_problem_from_text(PROBLEM_DESCRIPTION)
    prompt = utils.create_baseline_prompt(problem)

    result = huggingface.call_huggingface_api(client, HF_TEST_MODEL, prompt)

    assert result
    assert isinstance(result, str)


@requires_hf_token
@requires_unsloth
def test_run_problem_mode_generates_minizinc_with_huggingface_model(monkeypatch, capsys):
    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--problem", PROBLEM_DESCRIPTION,
        "--model", HF_TEST_MODEL,
        "--strategies", "baseline",
    ])

    main.main()

    generated_code = capsys.readouterr().out
    assert generated_code.strip()


# ── main --problem: end-to-end run from a plain-text description ───────────

@requires_openai_key
@pytest.mark.parametrize("input_mode", ["text", "file"])
@pytest.mark.parametrize("strategy", ALL_REAL_STRATEGIES)
def test_run_problem_mode_generates_minizinc_for_every_strategy_and_input_mode(
    strategy, input_mode, tmp_path, monkeypatch, capsys
):
    # Real end-to-end run per strategy (including multi-call ones like agents/
    # gala, and knowledge_graph's on-the-fly .ttl generation for a problem with
    # no pre-built KG) and per --problem input mode (inline text vs. a .txt
    # file path, exercising the os.path.isfile() branch in
    # main._run_problem_mode). Uses gpt-4 rather than gpt-4o/reasoning models
    # to keep an 18-call real-API sweep fast and cheap; strategy/input wiring
    # is what's under test here, not model quality.
    if input_mode == "file":
        problem_file = tmp_path / "problem.txt"
        problem_file.write_text(PROBLEM_DESCRIPTION)
        problem_arg = str(problem_file)
    else:
        problem_arg = PROBLEM_DESCRIPTION

    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--problem", problem_arg,
        "--model", "gpt-4",
        "--strategies", strategy,
    ])

    main.main()

    generated_code = capsys.readouterr().out
    assert generated_code.strip()


# ── main batch mode: one problem id, one strategy, real dataset + API ──────

@requires_openai_key
def test_main_batch_mode_single_problem_single_strategy(tmp_path, monkeypatch):
    output_dir = str(tmp_path / "output")

    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--model", "gpt-4o",
        "--strategies", "baseline",
        "--problem-ids", "0",
        "--output-dir", output_dir,
    ])

    main.main()

    summary_path = Path(output_dir) / "gpt-4o" / "summary.json"
    assert summary_path.exists()


@requires_openai_key
def test_main_batch_mode_multiple_problem_ids_writes_one_file_each(tmp_path, monkeypatch):
    output_dir = str(tmp_path / "output")

    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--model", "gpt-4o",
        "--strategies", "baseline",
        "--problem-ids", "0", "1",
        "--output-dir", output_dir,
    ])

    main.main()

    strategy_dir = Path(output_dir) / "gpt-4o" / "baseline"
    generated = list(strategy_dir.glob("*.mzn"))
    assert len(generated) == 2
    assert all(f.stat().st_size > 0 for f in generated)

    summary = json.loads((Path(output_dir) / "gpt-4o" / "summary.json").read_text())
    assert summary["_metadata"]["num_instances"] == 2
    assert summary["baseline"]["success"] + summary["baseline"]["failed"] == 2


@requires_openai_key
def test_main_batch_mode_skips_already_processed_problem(tmp_path, monkeypatch):
    # --output-dir must not already exist (main.py prompts interactively
    # otherwise), so we can't pre-seed a solution file there. Instead, list
    # the same problem id twice: the second occurrence hits
    # check_already_processed against the file the first occurrence just
    # wrote, so it's skipped without a second API call.
    output_dir = str(tmp_path / "output")

    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--model", "gpt-4o",
        "--strategies", "baseline",
        "--problem-ids", "0", "0",
        "--output-dir", output_dir,
    ])

    main.main()

    strategy_dir = Path(output_dir) / "gpt-4o" / "baseline"
    generated = list(strategy_dir.glob("*.mzn"))
    assert len(generated) == 1  # duplicate id produced one file, not two

    summary = json.loads((Path(output_dir) / "gpt-4o" / "summary.json").read_text())
    assert summary["baseline"]["success"] == 1
    assert summary["baseline"]["failed"] == 0


@requires_openai_key
def test_main_batch_mode_problem_ids_by_identifier(tmp_path, monkeypatch):
    # --problem-ids also accepts a problem identifier string (e.g. nlp4lp_58),
    # not just a numeric index. Look the identifier up dynamically against the
    # same verified-only view main.py itself would use (rather than hardcoding
    # a specific dataset id, which could go stale), so this stays valid as the
    # real dataset evolves.
    dataset = utils.load_text2zinc_dataset().filter(lambda x: x["is_verified"])
    identifier = utils.get_problem_identifier(dataset[0], 0)

    output_dir = str(tmp_path / "output")
    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--model", "gpt-4o",
        "--strategies", "baseline",
        "--problem-ids", identifier,
        "--output-dir", output_dir,
    ])

    main.main()

    generated = Path(output_dir) / "gpt-4o" / "baseline" / f"{identifier}.mzn"
    assert generated.exists()
    assert generated.stat().st_size > 0


@requires_openai_key
def test_main_batch_mode_dataset_path_generates_for_local_dataset(tmp_path, monkeypatch):
    # --dataset-path against a small locally-edited CSV instead of the default
    # HuggingFace dataset. No --problem-ids given, so this also covers the
    # "process every row" loop body cheaply (2 rows) instead of against the
    # full real dataset.
    csv_path = _write_tiny_dataset_csv(tmp_path, rows=[
        {"identifier": "local_p0", "source": "local_test", "is_verified": True},
        {"identifier": "local_p1", "source": "local_test", "is_verified": True},
    ])
    output_dir = str(tmp_path / "output")

    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--model", "gpt-4o",
        "--strategies", "baseline",
        "--dataset-path", str(csv_path),
        "--output-dir", output_dir,
    ])

    main.main()

    strategy_dir = Path(output_dir) / "gpt-4o" / "baseline"
    generated = list(strategy_dir.glob("*.mzn"))
    assert len(generated) == 2
    assert all(f.stat().st_size > 0 for f in generated)


# ── generate_knowledge_graph.py: real OpenAI call, opt-in only ──────────────

@requires_openai_key
def test_generate_knowledge_graph_creates_ttl_for_real_problem(tmp_path):
    import openai

    from text2model import generate_knowledge_graph as gkg

    problem = utils.create_problem_from_text(PROBLEM_DESCRIPTION)
    client = openai.OpenAI()
    original_config = dict(utils.API_CONFIG)
    utils.API_CONFIG.update({"model": "gpt-4o-mini", "temperature": 0, "max_tokens": 2000})
    try:
        prompt = gkg.create_kg_prompt(problem)
        solution = utils.call_openai_api(client, prompt)
    finally:
        utils.API_CONFIG.clear()
        utils.API_CONFIG.update(original_config)

    assert solution

    gkg.save_kg_solution(str(tmp_path), "user_problem", solution)
    ttl_path = tmp_path / "user_problem.ttl"
    assert ttl_path.exists()
    assert ttl_path.read_text().strip()
