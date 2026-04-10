% Parameters
int: max_total_properties = 1000;
int: cost_X = 300000;
int: cost_Y = 200000;

% Variables
var 0..max_total_properties: X;
var 0..max_total_properties: Y;

% Constraints
constraint X + Y <= max_total_properties;
constraint X >= 3 * Y;

% Objective
solve minimize cost_X * X + cost_Y * Y;