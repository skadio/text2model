% Parameters (with values embedded)
int: max_budget = 10000;
int: min_impact_req = 40000;

int: impact_coeff_X = 10;
int: impact_coeff_Y = 4;

int: cost_per_dollar_X = 50;
int: cost_per_dollar_Y = 30;

% Variables
var 0..max_budget: x; % budget allocated to project X (integer dollars)
var 0..max_budget: y; % budget allocated to project Y (integer dollars)

% Constraints
constraint x + y <= max_budget;
constraint impact_coeff_X * x + impact_coeff_Y * y >= min_impact_req;

% Objective
solve minimize cost_per_dollar_X * x + cost_per_dollar_Y * y;