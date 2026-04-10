% Parameters
int: max_total_alloc = 100;
int: min_effectiveness = 50;
int: max_diff = 30;

int: cost_x = 5;
int: cost_y = 8;

% Variables
var 0..max_total_alloc: x;
var 0..max_total_alloc: y;
var 0..(cost_x*max_total_alloc + cost_y*max_total_alloc): total_cost;

% Constraints
constraint x + y <= max_total_alloc;
constraint 2*x + y >= min_effectiveness;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;