% Parameters
int: max_units = 10000;
int: min_strength = 7000;
int: max_diff = 2000;
int: costX = 5000;
int: costY = 3000;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..(costX*max_units + costY*max_units): total_support;

% Constraints
constraint X + Y <= max_units;
constraint 2*X + Y >= min_strength;
constraint X - 2*Y <= max_diff;

constraint total_support = costX*X + costY*Y;

% Objective
solve minimize total_support;