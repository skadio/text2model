% Parameters (with values embedded)
int: min_requirement = 50000;
int: max_risk_limit  = 100000;
int: cost_bond = 7;
int: cost_stock = 5;

% Variables
var 0..100000: bonds;   % whole number of bond units
var 0..100000: stocks;  % whole number of stock units
var 0..(cost_bond*100000 + cost_stock*100000): total_cost;

% Constraints
constraint 2*bonds + 3*stocks >= min_requirement;
constraint 3*bonds + 2*stocks <= max_risk_limit;

constraint total_cost = cost_bond*bonds + cost_stock*stocks;

% Objective
solve minimize total_cost;