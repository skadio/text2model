% Parameters
int: max_total_units = 2000;
int: min_strength = 5000;

int: strength_X = 3;
int: strength_Y = 4;

int: cost_X = 5;
int: cost_Y = 10;

% Variables
var 0..max_total_units: x;
var 0..max_total_units: y;

var 0..(cost_X * max_total_units + cost_Y * max_total_units): total_cost;

% Constraints
constraint x + y <= max_total_units;
constraint strength_X * x + strength_Y * y >= min_strength;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;