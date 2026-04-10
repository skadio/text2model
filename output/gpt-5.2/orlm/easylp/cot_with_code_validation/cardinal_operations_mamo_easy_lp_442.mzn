% Parameters
int: max_total_budget = 1000;
int: min_effectiveness = 500;
int: max_budget_diff = 300;

int: costX = 5;
int: costY = 3;

% Variables
var 0..max_total_budget: x; % budget for department X (whole dollars)
var 0..max_total_budget: y; % budget for department Y (whole dollars)
var 0..(costX*max_total_budget + costY*max_total_budget): total_cost;

% Constraints
constraint x + y <= max_total_budget;
constraint 2*x + y >= min_effectiveness;
constraint abs(x - y) <= max_budget_diff;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;