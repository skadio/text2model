% Parameters
int: min_service = 10;
int: max_budget = 30;

int: costX = 4;
int: costY = 5;

% Variables
var 0..max_budget: x;
var 0..max_budget: y;

var 0..(costX*max_budget + costY*max_budget): total_cost;

% Constraints
constraint x + 3*y >= min_service;
constraint 2*x + y <= max_budget;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;