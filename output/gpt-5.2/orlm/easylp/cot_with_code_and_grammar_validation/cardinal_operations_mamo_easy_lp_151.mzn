% Parameters
int: capacity = 100;
int: min_value = 150;

int: value_x = 2;
int: value_y = 3;

int: cost_x = 4;
int: cost_y = 5;

% Variables
var 0..capacity: x;  % tons of cargo X (integer)
var 0..capacity: y;  % tons of cargo Y (integer)
var 0..(cost_x*capacity + cost_y*capacity): total_cost;

% Constraints
constraint x + y <= capacity;
constraint value_x * x + value_y * y >= min_value;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;