% Parameters
int: cost_stock = 5;
int: cost_bond  = 3;

int: min_combo = 10000;
int: max_diff  = 5000;

% Variables
var 0..2000: stocks;
var 0..2000: bonds;

var 0..1000000: total_cost;

% Constraints
constraint 2 * stocks + 4 * bonds >= min_combo;
constraint 3 * stocks - bonds <= max_diff;

constraint total_cost = cost_stock * stocks + cost_bond * bonds;

% Objective
solve minimize total_cost;