% Parameters
int: capacity = 100;
int: min_value = 150;
int: value_X = 2;
int: value_Y = 3;
int: cost_X = 4;
int: cost_Y = 5;

% Variables
var 0..capacity: x; % tons of cargo X
var 0..capacity: y; % tons of cargo Y
var 0..(cost_X*capacity + cost_Y*capacity): total_cost;

% Constraints
constraint x + y <= capacity;
constraint value_X * x + value_Y * y >= min_value;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;