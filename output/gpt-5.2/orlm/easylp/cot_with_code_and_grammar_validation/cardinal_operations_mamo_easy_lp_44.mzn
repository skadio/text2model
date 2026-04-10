% Parameters
int: max_total_alloc = 100;
int: min_effectiveness = 20;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..max_total_alloc: X;
var 0..max_total_alloc: Y;
var 0..(max_total_alloc * max(cost_x, cost_y)): total_resource;

% Constraints
constraint X + Y <= max_total_alloc;
constraint X + Y >= min_effectiveness;
constraint total_resource = cost_x * X + cost_y * Y;

% Objective
solve minimize total_resource;