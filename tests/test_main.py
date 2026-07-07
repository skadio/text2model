"""Basic offline tests for text2model.main — no network, API key, or MiniZinc binary required."""
from text2model import main


def test_strategy_map_covers_all_documented_strategies():
    expected = {
        "baseline", "cot", "knowledge_graph",
        "cot_with_code_validation", "cot_with_grammar_validation",
        "cot_with_code_and_grammar_validation",
        "agents", "agents_with_code_validation", "gala",
    }
    assert expected == set(main._STRATEGY_MAP.keys())


def test_check_already_processed_false_when_missing(tmp_path):
    assert main.check_already_processed(str(tmp_path), "prob_1") is False


def test_check_already_processed_false_for_empty_file(tmp_path):
    (tmp_path / "prob_1.mzn").write_text("")
    assert main.check_already_processed(str(tmp_path), "prob_1") is False


def test_check_already_processed_true_when_present(tmp_path):
    (tmp_path / "prob_1.mzn").write_text("var int: x;")
    assert main.check_already_processed(str(tmp_path), "prob_1") is True


def test_run_baseline_strategy_saves_solution_on_success(tmp_path, monkeypatch):
    problem = {
        "input.json": repr({
            "description": "desc",
            "parameters": [],
            "metadata": {"objective": "unknown", "identifier": "p1"},
        }),
        "data.dzn": "",
    }

    monkeypatch.setattr(main.utils, "call_api", lambda client, model, prompt: "var int: x;")

    result = main.run_baseline_strategy(None, "cot", problem, "p1", str(tmp_path))

    assert result is True
    assert (tmp_path / "p1.mzn").read_text() == "var int: x;"


def test_run_baseline_strategy_returns_false_when_api_fails(tmp_path, monkeypatch):
    problem = {
        "input.json": repr({
            "description": "desc",
            "parameters": [],
            "metadata": {"objective": "unknown", "identifier": "p1"},
        }),
        "data.dzn": "",
    }

    monkeypatch.setattr(main.utils, "call_api", lambda client, model, prompt: None)

    result = main.run_baseline_strategy(None, "cot", problem, "p1", str(tmp_path))

    assert result is False
    assert not (tmp_path / "p1.mzn").exists()
