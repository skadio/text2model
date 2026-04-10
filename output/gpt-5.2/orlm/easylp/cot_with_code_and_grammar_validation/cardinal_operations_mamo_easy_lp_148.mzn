% Parameters
int: demand = 50;
int: op_limit = 120;

int: costX = 7;
int: costY = 5;

% Variables
var 0..demand: x;  % number of ships X
var 0..demand: y;  % number of ships Y

var 0..(costX*demand + costY*demand): total_cost;

% Constraints
constraint x + y >= demand;
constraint 2*x + y <= op_limit;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;