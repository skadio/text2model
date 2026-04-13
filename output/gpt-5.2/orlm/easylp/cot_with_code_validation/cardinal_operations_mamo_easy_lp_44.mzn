% Parameters
int: max_total_resource = 100;
int: min_effectiveness = 20;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..max_total_resource: X;
var 0..max_total_resource: Y;
var 0..max_total_resource: total_resource = X + Y;

% Constraints
constraint X + Y <= max_total_resource;
constraint X + Y >= min_effectiveness;

% Objective
solve minimize total_resource;