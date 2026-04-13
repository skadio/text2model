% Parameters
int: capacity = 200;
int: demand = 400;

int: costX = 500;
int: costY = 300;

% Variables
var 0..capacity: X;
var 0..capacity: Y;

var 0..(costX * capacity + costY * capacity): total_cost;

% Constraints
constraint X + Y <= capacity;
constraint 3 * X + 2 * Y >= demand;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;