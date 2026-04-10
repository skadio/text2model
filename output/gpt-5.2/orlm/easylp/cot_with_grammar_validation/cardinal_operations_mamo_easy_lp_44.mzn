% Parameters
int: max_total_resources = 100;
int: min_effectiveness = 20;
int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..max_total_resources: total_resources = X + Y;

% Constraints
constraint X + Y <= max_total_resources;
constraint (1 * X) + (1 * Y) >= min_effectiveness;

% Objective
solve minimize (cost_x * X + cost_y * Y);