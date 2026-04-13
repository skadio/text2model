% Parameters
int: capacity = 300;
int: demand = 800;

int: costX = 50;
int: costY = 70;

% Variables
var 0..capacity: x;   % units of product X
var 0..capacity: y;   % units of product Y
var 0..(costX*capacity + costY*capacity): total_cost;

% Constraints
constraint x + y <= capacity;
constraint 3*x + 4*y >= demand;
constraint x >= y;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;