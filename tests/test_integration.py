"""Opt-in tests that hit real external dependencies.

These are NOT run in CI (see .github/workflows/tests.yml, which passes
`-m "not integration"`) and are skipped automatically whenever the
dependency they need isn't available locally:

- MiniZinc tests need the `minizinc` executable on PATH.
- OpenAI tests need OPENAI_API_KEY in the environment.

Run everything (offline + integration) locally with:
    pytest -m ""

Run only the integration subset with:
    pytest -m integration
"""
import json
import os
import shutil
import sys
from pathlib import Path

import pytest

from text2model import main, utils

pytestmark = pytest.mark.integration

requires_minizinc = pytest.mark.skipif(
    shutil.which("minizinc") is None,
    reason="minizinc executable not found on PATH",
)

requires_openai_key = pytest.mark.skipif(
    not os.getenv("OPENAI_API_KEY"),
    reason="OPENAI_API_KEY not set in the environment",
)


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


# ── main --problem: end-to-end run from a plain-text description ───────────

@requires_openai_key
def test_run_problem_mode_generates_minizinc_from_description(monkeypatch, capsys):
    problem_description = """A country produces fighter jets each year. Some of these jets must be set aside for pilot training instead of combat use. Year 1 production is 10 jets, and Year 2 production is 15 jets. Each training jet can train 5 pilots per year. Training runs for 2 years, starting in Year 1. Determine how many pilots will be trained in total by the end of Year 2."""

    monkeypatch.setattr(sys, "argv", [
        "text2model",
        "--problem", problem_description,
        "--model", "gpt-4o",
        "--strategies", "cot",
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
