% Parameters (with values embedded)
int: max_total_investment = 1000;
int: min_diff_bonds_over_stocks = 200;

int: cost_bonds = 10;
int: cost_stocks = 20;

% Variables
var 0..max_total_investment: bonds;
var 0..max_total_investment: stocks;
var 0..(cost_bonds*max_total_investment + cost_stocks*max_total_investment): total_cost;

% Constraints
constraint bonds + stocks <= max_total_investment;
constraint bonds >= stocks + min_diff_bonds_over_stocks;

constraint total_cost = cost_bonds*bonds + cost_stocks*stocks;

% Objective
solve minimize total_cost;