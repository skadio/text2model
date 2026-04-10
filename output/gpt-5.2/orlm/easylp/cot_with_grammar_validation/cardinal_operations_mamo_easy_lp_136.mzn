% Parameters
int: budget_max = 200;
int: budget_min = 50;
int: costX = 5;
int: costY = 8;

% Variables
var 0..budget_max: x;
var 0..budget_max: y;
var 0..(costX*budget_max + costY*budget_max): total_cost;

% Constraints
constraint x + y <= budget_max;
constraint x + y >= budget_min;

constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;