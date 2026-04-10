% Parameters
int: budget = 1000;
int: extra = 300;
int: costX = 4;
int: costY = 3;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(costX*budget + costY*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint x >= 2 * y + extra;
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;