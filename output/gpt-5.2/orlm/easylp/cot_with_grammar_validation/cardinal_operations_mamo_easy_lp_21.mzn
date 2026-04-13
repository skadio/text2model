% Parameters
int: cost_X = 5000;
int: cost_Y = 3000;
int: capacity = 1000;
int: demand = 2000;
int: wX = 3;
int: wY = 2;
int: min_diff = 150;

% Variables
var 0..capacity: x;
var 0..capacity: y;
var 0..(cost_X * capacity + cost_Y * capacity): total_cost;

% Constraints
constraint x + y <= capacity;
constraint wX * x + wY * y >= demand;
constraint x - y >= min_diff;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;