"""Basic offline tests for text2model.utils — no network, API key, or MiniZinc binary required."""
import os

import pytest

from text2model import utils


# ── extract_code_blocks ──────────────────────────────────────────────────────

def test_extract_code_blocks_returns_fenced_content():
    text = "Here you go:\n```minizinc\nvar int: x;\n```\nDone."
    assert utils.extract_code_blocks(text) == "var int: x;"


def test_extract_code_blocks_no_fence_returns_original():
    text = "no fenced code here"
    assert utils.extract_code_blocks(text) == text


def test_extract_code_blocks_returns_first_of_multiple():
    text = "```\nfirst\n```\nsome text\n```\nsecond\n```"
    assert utils.extract_code_blocks(text) == "first"


# ── extract_global_constraint ────────────────────────────────────────────────

def test_extract_global_constraint_reads_backticked_name():
    text = "Constraint: `all_different`\nsome more text"
    assert utils.extract_global_constraint(text) == "all_different"


# ── parse_dzn_string ──────────────────────────────────────────────────────────

def test_parse_dzn_string_extracts_param_value_pairs():
    dzn = "n = 5;\nm = 10;\n% just a comment line\narr = [1, 2, 3];"
    result = utils.parse_dzn_string(dzn)
    assert result == [
        ("n", "n = 5;"),
        ("m", "m = 10;"),
        ("arr", "arr = [1, 2, 3];"),
    ]


def test_parse_dzn_string_empty_input():
    assert utils.parse_dzn_string("") == []


# ── create_data_nomenclature ─────────────────────────────────────────────────

def test_create_data_nomenclature_empty_dzn_data_returns_empty_string():
    input_data = {"parameters": [{"symbol": "n", "definition": "count", "shape": []}]}
    assert utils.create_data_nomenclature(input_data, []) == ""


def test_create_data_nomenclature_no_parameters_returns_empty_string():
    input_data = {"parameters": []}
    dzn_data = [("n", "n = 5;")]
    assert utils.create_data_nomenclature(input_data, dzn_data) == ""


def test_create_data_nomenclature_formats_each_parameter():
    input_data = {
        "parameters": [
            {"symbol": "n", "definition": "number of items", "shape": []},
            {"symbol": "w", "definition": "weights", "shape": [3]},
        ]
    }
    dzn_data = [("n", "n = 5;"), ("w", "w = [1, 2, 3];")]
    result = utils.create_data_nomenclature(input_data, dzn_data)

    assert "1. n: number of items" in result
    assert "Example: n = 5;" in result
    assert "Shape: scalar" in result
    assert "2. w: weights" in result
    assert "Example: w = [1, 2, 3];" in result
    assert "Shape: [3]" in result


def test_create_data_nomenclature_missing_example_uses_placeholder():
    input_data = {"parameters": [{"symbol": "missing", "definition": "def", "shape": []}]}
    dzn_data = [("other", "other = 1;")]
    result = utils.create_data_nomenclature(input_data, dzn_data)
    assert "Example: missing = N/A;" in result


# ── prepare_problem_data / get_effective_input_data ──────────────────────────

def _make_problem(description="Maximize profit.", parameters=None, dzn_data=""):
    input_data = {
        "description": description,
        "parameters": parameters or [],
        "metadata": {"objective": "maximize", "identifier": "prob_1"},
    }
    return {"input.json": repr(input_data), "data.dzn": dzn_data}


def test_prepare_problem_data_parses_fields():
    problem = _make_problem(dzn_data="n = 5;")
    data = utils.prepare_problem_data(problem)

    assert data["description"] == "Maximize profit."
    assert data["objective_type"] == "maximize"
    assert data["identifier"] == "prob_1"
    assert data["dzn_data"] == [("n", "n = 5;")]


def test_prepare_problem_data_no_dzn():
    problem = _make_problem(dzn_data="")
    data = utils.prepare_problem_data(problem)
    assert data["dzn_data"] == []
    assert data["data_nomenclature"] == ""


def test_get_effective_input_data_returns_embed_instructions_when_empty():
    problem_data = {"data_nomenclature": ""}
    result = utils.get_effective_input_data(problem_data)
    assert "embed all data directly" in result


def test_get_effective_input_data_returns_nomenclature_when_present():
    problem_data = {"data_nomenclature": "1. n: count\nExample: n = 5;\nShape: scalar"}
    assert utils.get_effective_input_data(problem_data) == problem_data["data_nomenclature"]


# ── create_baseline_prompt ───────────────────────────────────────────────────

def test_create_baseline_prompt_with_parameters_mentions_dzn_file():
    problem = _make_problem(
        parameters=[{"symbol": "n", "definition": "count", "shape": []}],
        dzn_data="n = 5;",
    )
    prompt = utils.create_baseline_prompt(problem)
    assert ".dzn file" in prompt
    assert "Maximize profit." in prompt


def test_create_baseline_prompt_without_parameters_embeds_data():
    problem = _make_problem(parameters=[], dzn_data="")
    prompt = utils.create_baseline_prompt(problem)
    assert "embed them directly" in prompt


# ── create_problem_from_text ─────────────────────────────────────────────────

def test_create_problem_from_text_builds_dataset_compatible_dict():
    problem = utils.create_problem_from_text("Some problem description")
    assert problem["data.dzn"] == ""
    data = utils.prepare_problem_data(problem)
    assert data["description"] == "Some problem description"
    assert data["identifier"] == "user_problem"


# ── save_solution / load_file ────────────────────────────────────────────────

def test_save_solution_writes_file(tmp_path):
    utils.save_solution(str(tmp_path), "prob_1", "var int: x;")
    output_path = tmp_path / "prob_1.mzn"
    assert output_path.read_text() == "var int: x;"


def test_load_file_reads_existing_file(tmp_path):
    f = tmp_path / "prompt.txt"
    f.write_text("hello prompt")
    assert utils.load_file(str(f)) == "hello prompt"


def test_load_file_missing_file_returns_empty_string():
    assert utils.load_file("/nonexistent/path/does_not_exist.txt") == ""


def test_load_file_resolves_bundled_prompt_from_package():
    # Not present in CWD, but shipped inside the package directory.
    content = utils.load_file("prompts/cot_prompt.txt")
    assert content != ""


# ── get_problem_source / get_problem_identifier / get_cardinal_ops_subfolder ─

def test_get_problem_source_returns_metadata_source():
    input_data = {"metadata": {"source": "CSPLib"}}
    problem = {"input.json": repr(input_data)}
    assert utils.get_problem_source(problem) == "CSPLib"


def test_get_problem_source_missing_returns_none():
    problem = {"input.json": "not a dict"}
    assert utils.get_problem_source(problem) is None


def test_get_problem_identifier_uses_existing_identifier():
    input_data = {"metadata": {"identifier": "my_problem"}}
    problem = {"input.json": repr(input_data)}
    assert utils.get_problem_identifier(problem, 0) == "my_problem"


def test_get_problem_identifier_falls_back_to_source_and_index():
    input_data = {"metadata": {"source": "CSPLib", "identifier": ""}}
    problem = {"input.json": repr(input_data)}
    assert utils.get_problem_identifier(problem, 7) == "csplib_problem_7"


def test_get_problem_identifier_disambiguates_shared_identifiers():
    input_data = {"metadata": {"identifier": "easy_lp"}}
    problem = {"input.json": repr(input_data)}
    assert utils.get_problem_identifier(problem, 3) == "easy_lp_3"


@pytest.mark.parametrize(
    "source,identifier,expected",
    [
        ("cardinal_operations_mamo", "easy_lp", "easylp"),
        ("cardinal_operations_mamo", "complex_lp", "complexlp"),
        ("cardinal_operations_mamo", "other", "mamo"),
        ("cardinal_operations_nl4opt", "", "nl4opt"),
        ("cardinal_operations_industryor", "", "industryor"),
        ("cardinal_operations_foo", "", "foo"),
        ("CSPLib", "", None),
    ],
)
def test_get_cardinal_ops_subfolder(source, identifier, expected):
    input_data = {"metadata": {"source": source, "identifier": identifier}}
    problem = {"input.json": repr(input_data)}
    assert utils.get_cardinal_ops_subfolder(problem) == expected


# ── filter_dataset_by_source / get_available_sources ────────────────────────

def _make_dataset(sources):
    return [
        {"input.json": repr({"metadata": {"source": s}})} for s in sources
    ]


def test_get_available_sources_returns_sorted_unique_sources():
    dataset = _make_dataset(["CSPLib", "nlp4lp", "CSPLib"])
    assert utils.get_available_sources(dataset) == ["CSPLib", "nlp4lp"]


def test_filter_dataset_by_source_partial_match():
    dataset = _make_dataset(["cardinal_operations_mamo", "CSPLib", "cardinal_operations_nl4opt"])

    class FakeDataset(list):
        def filter(self, fn):
            return FakeDataset([p for p in self if fn(p)])

    fake = FakeDataset(dataset)
    filtered = utils.filter_dataset_by_source(fake, "cardinal_operations")
    assert len(filtered) == 2
