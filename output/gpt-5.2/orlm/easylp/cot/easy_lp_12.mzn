% Parameters (with values embedded)
int: budget = 100;
int: min_effectiveness = 50;
int: max_diff = 30;
int: cost_x = 5;
int: cost_y = 8;

% Variables
var 0..budget: x;  % allocation to project X (integer)
var 0..budget: y;  % allocation to project Y (integer)
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint 2*x + y >= min_effectiveness;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;