"""LLM Modeling Copilot strategies: one module per strategy, registered here.

Add a new strategy by dropping a `run_<name>_strategy(client, model, problem,
problem_identifier, output_dir)` function in its own module and adding an
entry to STRATEGY_MAP below.
"""
from text2model.copilots.agents import run_agents_strategy
from text2model.copilots.baseline import run_baseline_strategy
from text2model.copilots.cot import run_cot_strategy
from text2model.copilots.cot_with_code_and_grammar_validation import (
    run_cot_with_code_and_grammar_validation_strategy,
)
from text2model.copilots.cot_with_code_validation import run_cot_with_code_validation_strategy
from text2model.copilots.cot_with_grammar_validation import run_cot_with_grammar_validation_strategy
from text2model.copilots.gala import run_gala_strategy
from text2model.copilots.knowledge_graph import run_knowledge_graph_strategy

STRATEGY_MAP = {
    'baseline': run_baseline_strategy,
    'cot': run_cot_strategy,
    'knowledge_graph': run_knowledge_graph_strategy,
    'cot_with_code_validation': run_cot_with_code_validation_strategy,
    'cot_with_grammar_validation': run_cot_with_grammar_validation_strategy,
    'cot_with_code_and_grammar_validation': run_cot_with_code_and_grammar_validation_strategy,
    'agents': lambda c, m, p, i, o: run_agents_strategy(c, m, p, i, o, validate=False),
    'agents_with_code_validation': run_agents_strategy,
    'gala': run_gala_strategy,
}
