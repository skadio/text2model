% Parameters
int: max_total_properties = 1000;
int: cost_X = 300000;
int: cost_Y = 200000;

% Variables
var 0..max_total_properties: x;
var 0..max_total_properties: y;

% Constraints
constraint x + y <= max_total_properties;
constraint x >= 3 * y;

% Objective
solve minimize cost_X * x + cost_Y * y;