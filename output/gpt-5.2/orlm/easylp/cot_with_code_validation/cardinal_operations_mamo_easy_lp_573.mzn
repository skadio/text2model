% Parameters
int: max_units = 150;
int: min_strength = 100;
int: max_diff_zx = 30;
int: min_y_minus_z = 20;

int: strength_x_coeff = 3;
int: strength_y_coeff = 4;

int: cost_x = 10000;
int: cost_y = 2000;
int: cost_z = 500;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(cost_x*max_units + cost_y*max_units + cost_z*max_units): total_support;

% Constraints
constraint X + Y + Z <= max_units;

constraint strength_x_coeff * X + strength_y_coeff * Y >= min_strength;

constraint abs(Z - X) <= max_diff_zx;

constraint Y - Z >= min_y_minus_z;

constraint total_support = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_support;