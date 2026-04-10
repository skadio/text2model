% Parameters
int: min_invest_1 = 50000;   % 2*bonds + 3*stocks >= 50000
int: max_invest_2 = 100000;  % 3*bonds + 2*stocks <= 100000
int: cost_bond = 7;
int: cost_stock = 5;

% Variables
var 0..50000: bonds;
var 0..50000: stocks;
var 0..(cost_bond*50000 + cost_stock*50000): total_cost;

% Constraints
constraint 2*bonds + 3*stocks >= min_invest_1;
constraint 3*bonds + 2*stocks <= max_invest_2;

constraint total_cost = cost_bond*bonds + cost_stock*stocks;

% Objective
solve minimize total_cost;