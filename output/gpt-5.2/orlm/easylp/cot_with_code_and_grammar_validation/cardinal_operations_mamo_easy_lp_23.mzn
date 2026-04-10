% Parameters
int: capacity = 200;
int: demand = 400;
int: coefX = 3;
int: coefY = 2;
int: costX = 500;
int: costY = 300;

% Variables
var 0..capacity: x;
var 0..capacity: y;
var 0..(costX * capacity + costY * capacity): total_cost;

% Constraints
constraint x + y <= capacity;
constraint coefX * x + coefY * y >= demand;
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;