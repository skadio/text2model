% Parameters
int: support_X = 5000;
int: support_Y = 3000;
int: min_units = 50;
int: strength_X = 5;
int: strength_Y = 3;
int: max_strength = 200;

% Variables
var 0..max_strength div strength_X: x;
var 0..max_strength div strength_Y: y;

% Constraints
constraint x + y >= min_units;
constraint strength_X * x + strength_Y * y <= max_strength;

% Objective
solve minimize support_X * x + support_Y * y;