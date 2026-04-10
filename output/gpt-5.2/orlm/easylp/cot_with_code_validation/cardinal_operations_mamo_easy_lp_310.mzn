% Parameters
int: max_units = 100;
int: min_strength = 50;
int: max_diff_zy = 30;

int: strength_x = 5;
int: strength_y = 3;

int: cost_x = 500;
int: cost_y = 600;
int: cost_z = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(cost_x*max_units + cost_y*max_units + cost_z*max_units): total_support;

% Constraints
constraint X + Y + Z <= max_units;

constraint strength_x * X + strength_y * Y >= min_strength;

constraint abs(Z - Y) <= max_diff_zy;

constraint total_support = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_support;