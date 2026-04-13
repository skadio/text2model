% Parameters
int: min_total_units = 100;
int: max_strength = 600;

int: strength_x = 5;
int: strength_y = 3;

int: cost_x = 5000;
int: cost_y = 3000;

% Variables
var 0..min_total_units: x;
var 0..min_total_units: y;

var 0..(cost_x*min_total_units + cost_y*min_total_units): total_cost;

% Constraints
constraint x + y >= min_total_units;
constraint strength_x * x + strength_y * y <= max_strength;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;