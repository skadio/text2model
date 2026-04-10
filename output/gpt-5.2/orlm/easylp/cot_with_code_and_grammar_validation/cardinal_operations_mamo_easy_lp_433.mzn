% Parameters
int: budget = 1000;
int: min_diff = 200; % bonds >= stocks + 200
int: cost_bonds = 10;
int: cost_stocks = 20;

% Variables
var 0..budget: bonds;
var 0..budget: stocks;
var 0..(cost_bonds*budget + cost_stocks*budget): total_cost;

% Constraints
constraint bonds + stocks <= budget;
constraint bonds >= stocks + min_diff;
constraint total_cost = cost_bonds*bonds + cost_stocks*stocks;

% Objective
solve minimize total_cost;