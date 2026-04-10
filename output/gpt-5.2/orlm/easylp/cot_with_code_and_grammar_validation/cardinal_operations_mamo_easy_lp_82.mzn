% Parameters
int: max_total_units = 2000;
int: min_strength = 5000;
int: strength_x = 3;
int: strength_y = 4;
int: cost_x = 5;
int: cost_y = 10;

% Variables
var 0..max_total_units: x;
var 0..max_total_units: y;
var 0..(cost_x*max_total_units + cost_y*max_total_units): total_cost;

% Constraints
constraint x + y <= max_total_units;
constraint strength_x * x + strength_y * y >= min_strength;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;