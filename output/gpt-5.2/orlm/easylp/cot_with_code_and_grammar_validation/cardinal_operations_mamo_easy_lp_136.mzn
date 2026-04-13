% Parameters
int: max_total_alloc = 200;
int: min_total_alloc = 50;
int: cost_X = 5;
int: cost_Y = 8;

% Variables
var 0..max_total_alloc: x;
var 0..max_total_alloc: y;
var 0..cost_X*max_total_alloc + cost_Y*max_total_alloc: total_cost;

% Constraints
constraint x + y <= max_total_alloc;
constraint x + y >= min_total_alloc;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;