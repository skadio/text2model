% Parameters
int: cost_X = 50;
int: cost_Y = 70;
int: max_total = 1000;
int: min_X = 300;
int: min_Y = 200;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(cost_X * max_total + cost_Y * max_total): total_cost;

% Constraints
constraint x >= min_X;
constraint y >= min_Y;
constraint x + y <= max_total;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;