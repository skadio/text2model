% Parameters (with values embedded)
int: max_units = 1000;
int: min_2x_plus_y = 200;
int: max_diff_xz = 50;
int: min_y_plus_z = 400;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(costX*max_units + costY*max_units + costZ*max_units): total_support;

% Constraints
constraint X + Y + Z <= max_units;
constraint 2*X + Y >= min_2x_plus_y;
constraint abs(X - Z) <= max_diff_xz;
constraint Y + Z >= min_y_plus_z;

constraint total_support = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_support;