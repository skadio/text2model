% Parameters
int: budget = 1000;
int: extra_x = 300;
int: cost_x = 4;
int: cost_y = 3;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint x >= 2 * y + extra_x;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;