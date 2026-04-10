% Parameters
int: budget = 200;
int: min_alloc = 50;
int: costX = 5;
int: costY = 8;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(costX*budget + costY*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint x + y >= min_alloc;
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;