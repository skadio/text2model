% Parameters
int: demand = 50;
int: op_limit = 120;
int: cost_x = 7;
int: cost_y = 5;

% Variables
var 0..demand: x;              % number of ships X
var 0..demand: y;              % number of ships Y
var 0..(cost_x*demand + cost_y*demand): total_cost;

% Constraints
constraint x + y >= demand;
constraint 2*x + y <= op_limit;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;