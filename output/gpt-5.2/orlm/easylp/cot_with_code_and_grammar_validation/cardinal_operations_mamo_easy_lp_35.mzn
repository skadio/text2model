% Parameters
int: min_risk_return = 50000;     % 2*stocks + bonds >= 50000
int: max_balance_diff = 20000;    % stocks - 2*bonds <= 20000
int: cost_stock = 4;
int: cost_bond = 3;

% Variables
var 0..50000: stocks;
var 0..50000: bonds;
var 0..(cost_stock*50000 + cost_bond*50000): total_cost;

% Constraints
constraint 2*stocks + bonds >= min_risk_return;
constraint stocks - 2*bonds <= max_balance_diff;

constraint total_cost = cost_stock*stocks + cost_bond*bonds;

% Objective
solve minimize total_cost;