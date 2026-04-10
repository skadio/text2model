% Parameters
int: max_total = 1000;
int: min_X = 400;
int: min_Y = 300;
int: cost_X = 50;
int: cost_Y = 60;

% Variables
var min_X..max_total: x;
var min_Y..max_total: y;
var 0..(cost_X*max_total + cost_Y*max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;