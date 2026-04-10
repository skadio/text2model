% Parameters
int: total_budget_cap = 1000;
int: min_effectiveness = 500;
int: max_budget_diff = 300;

int: cost_X = 5;
int: cost_Y = 3;

% Variables
var 0..total_budget_cap: x; % budget for department X (whole dollars)
var 0..total_budget_cap: y; % budget for department Y (whole dollars)

var 0..(cost_X * total_budget_cap + cost_Y * total_budget_cap): total_cost;

% Constraints
constraint x + y <= total_budget_cap;
constraint 2 * x + y >= min_effectiveness;
constraint abs(x - y) <= max_budget_diff;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;