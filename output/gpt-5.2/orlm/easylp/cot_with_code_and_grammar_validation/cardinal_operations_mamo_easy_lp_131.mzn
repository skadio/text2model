% Parameters
int: max_budget = 10000;
int: min_combined_impact = 40000;

int: impact_coeff_X = 10;
int: impact_coeff_Y = 4;

int: cost_X = 50;
int: cost_Y = 30;

% Variables
var 0..max_budget: x; % budget for project X (integer dollars)
var 0..max_budget: y; % budget for project Y (integer dollars)

var 0..(cost_X * max_budget + cost_Y * max_budget): total_cost;

% Constraints
constraint x + y <= max_budget;

constraint impact_coeff_X * x + impact_coeff_Y * y >= min_combined_impact;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;