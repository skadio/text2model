% Parameters (with values embedded)
int: min_service = 10;
int: max_budget = 30;
int: costX = 4;
int: costY = 5;

% Variables
var 0..100: x; % units allocated to department X
var 0..100: y; % units allocated to department Y

% Constraints
constraint x + 3*y >= min_service;
constraint 2*x + y <= max_budget;

% Objective
var int: total_cost = costX*x + costY*y;
solve minimize total_cost;