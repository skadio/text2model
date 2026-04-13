% Parameters (with values embedded)
int: max_budget = 100;
int: min_total_alloc = 20;
int: max_diff = 30;
int: costX = 6;
int: costY = 2;

% Variables
var 0..100: x; % allocation to project X (integer, non-negative)
var 0..100: y; % allocation to project Y (integer, non-negative)
var 0..(costX*100 + costY*100): total_cost;

% Constraints
constraint 4*x + 5*y <= max_budget;
constraint x + y >= min_total_alloc;
constraint abs(2*x - y) <= max_diff;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;