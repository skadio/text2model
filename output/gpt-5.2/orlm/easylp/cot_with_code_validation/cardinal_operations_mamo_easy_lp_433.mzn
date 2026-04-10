% Parameters
int: budget = 1000;
int: min_gap = 200;          % bonds must be at least min_gap more than stocks
int: cost_bond = 10;
int: cost_stock = 20;

% Variables
var 0..budget: bonds;
var 0..budget: stocks;
var 0..(cost_bond*budget + cost_stock*budget): total_cost;

% Constraints
constraint bonds + stocks <= budget;
constraint bonds >= stocks + min_gap;

constraint total_cost = cost_bond*bonds + cost_stock*stocks;

% Objective
solve minimize total_cost;