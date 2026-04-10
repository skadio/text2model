% Parameters
int: cost_stock = 5;
int: cost_bond  = 3;

int: min_req = 10000;
int: max_risk = 5000;

% Variables
var 0..100000: stocks;
var 0..100000: bonds;

% Constraints
constraint 2 * stocks + 4 * bonds >= min_req;
constraint 3 * stocks - bonds <= max_risk;

% Objective
solve minimize cost_stock * stocks + cost_bond * bonds;