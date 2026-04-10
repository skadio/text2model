% Parameters (with values embedded)
int: cost_stock = 5;
int: cost_bond  = 3;

int: min_requirement = 10000;      % 2*stocks + 4*bonds >= 10000
int: max_risk_limit  = 5000;       % 3*stocks - bonds <= 5000

% Variables
var 0..10000: stocks;
var 0..10000: bonds;

% Constraints
constraint 2 * stocks + 4 * bonds >= min_requirement;
constraint 3 * stocks - bonds <= max_risk_limit;

% Objective
solve minimize cost_stock * stocks + cost_bond * bonds;