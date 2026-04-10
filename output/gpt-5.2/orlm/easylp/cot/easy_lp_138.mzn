% Parameters (with values embedded)
int: min_total_units = 100;
int: max_strength = 600;
int: strength_X = 5;
int: strength_Y = 3;
int: cost_X = 5000;
int: cost_Y = 3000;

% Variables
var 0..min_total_units: X;
var 0..min_total_units: Y;
var 0..(cost_X*min_total_units + cost_Y*min_total_units): total_cost;

% Constraints
constraint X + Y >= min_total_units;
constraint strength_X * X + strength_Y * Y <= max_strength;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;