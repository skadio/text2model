% Parameters
int: capacity = 1000;
int: metric_min = 500;
int: balance_max = 400;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..capacity: x;
var 0..capacity: y;
var 0..capacity: z;

var 0..(costX*capacity + costY*capacity + costZ*capacity): total_cost;

% Constraints
constraint x + y + z <= capacity;

constraint 5*x + 3*y - z >= metric_min;

constraint x + z - y <= balance_max;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;