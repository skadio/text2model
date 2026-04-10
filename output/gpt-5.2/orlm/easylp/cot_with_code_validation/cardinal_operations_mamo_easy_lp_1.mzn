% Parameters
int: max_budget = 2000;
int: costX = 50;
int: costY = 100;
int: min_diff = 500;

% Variables
var 0..max_budget: x;
var 0..max_budget: y;
var 0..(costX*max_budget + costY*max_budget): total_cost;

% Constraints
constraint x + y <= max_budget;
constraint 3 * x - 2 * y >= min_diff;
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;