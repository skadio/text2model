"""Basic offline tests for text2model.main — no network, API key, or MiniZinc binary required."""
from pathlib import Path

from text2model import copilots, huggingface, main, utils
from text2model.copilots import baseline


def test_strategy_map_covers_all_documented_strategies():
    expected = {
        "baseline", "cot", "knowledge_graph",
        "cot_with_code", "cot_with_grammar",
        "cot_with_code_and_grammar",
        "agents", "agents_with_code", "gala",
    }
    assert expected == set(copilots.STRATEGY_MAP.keys())
    assert main._STRATEGY_MAP is copilots.STRATEGY_MAP


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

    monkeypatch.setattr(baseline.utils, "call_api", lambda client, model, prompt: "var int: x;")

    result = baseline.run_baseline_strategy(None, "cot", problem, "p1", str(tmp_path))

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

    monkeypatch.setattr(baseline.utils, "call_api", lambda client, model, prompt: None)

    result = baseline.run_baseline_strategy(None, "cot", problem, "p1", str(tmp_path))

    assert result is False
    assert not (tmp_path / "p1.mzn").exists()


def test_huggingface_models_registered_in_available_models():
    for alias in huggingface.HUGGINGFACE_MODELS:
        assert alias in main.AVAILABLE_MODELS


def test_call_api_routes_huggingface_alias_to_huggingface_backend(monkeypatch):
    calls = {}

    def fake_call_huggingface_api(client, model, prompt):
        calls["args"] = (client, model, prompt)
        return "var int: x;"

    monkeypatch.setattr(huggingface, "call_huggingface_api", fake_call_huggingface_api)

    alias = next(iter(huggingface.HUGGINGFACE_MODELS))
    result = utils.call_api("fake-client", alias, "generate this")

    assert result == "var int: x;"
    assert calls["args"] == ("fake-client", alias, "generate this")


def test_init_client_loads_huggingface_model_without_api_key(monkeypatch):
    alias = next(iter(huggingface.HUGGINGFACE_MODELS))

    def fake_load(model_alias):
        assert model_alias == alias
        return ("fake-model", "fake-tokenizer")

    monkeypatch.setattr(huggingface, "load_huggingface_model", fake_load)

    class Args:
        model = alias
        api_key = None
        temperature = 0
        max_tokens = 4096
        sleep_time = 3
        reasoning_effort = None

    client = main._init_client(Args())

    assert client == ("fake-model", "fake-tokenizer")


def test_main_prints_help_without_error_for_bare_invocation(monkeypatch, capsys):
    monkeypatch.setattr(main.sys, "argv", ["text2model"])

    main.main()

    output = capsys.readouterr()
    assert "usage: text2model" in output.out
    assert output.err == ""


def test_main_lists_strategies_without_dataset_loading(monkeypatch, capsys):
    monkeypatch.setattr(main.sys, "argv", ["text2model", "--list-strategies"])

    main.main()

    output = capsys.readouterr().out
    assert "Available --strategies options:" in output
    for strategy in main.AVAILABLE_STRATEGIES:
        assert f"  - {strategy}" in output


def test_problem_mode_comments_cli_status_but_not_code(monkeypatch, capsys):
    def fake_init_client(args):
        return object()

    def fake_strategy(client, model, problem, problem_identifier, output_dir):
        Path(output_dir, "output.mzn").write_text("var int: x;")
        return True

    monkeypatch.setattr(main, "_init_client", fake_init_client)
    monkeypatch.setitem(main._STRATEGY_MAP, "cot", fake_strategy)
    monkeypatch.setattr(main.sys, "argv", [
        "text2model",
        "--problem",
        "turn this text into constraint model",
        "--strategies",
        "cot",
    ])

    main.main()

    output = capsys.readouterr()
    assert output.out.startswith("% Generating MiniZinc model using strategy 'cot' with model 'gpt-4'...")
    assert output.out.rstrip().endswith("var int: x;")
    assert output.err == ""
