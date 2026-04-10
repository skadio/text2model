% Parameters
int: max_units = 100;
int: strength_X = 5;
int: strength_Y = 3;
int: min_strength = 50;
int: max_diff_ZY = 30;

int: cost_X = 500;
int: cost_Y = 600;
int: cost_Z = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(max_units * max([cost_X, cost_Y, cost_Z])): total_support;

% Constraints
constraint X + Y + Z <= max_units;

constraint strength_X * X + strength_Y * Y >= min_strength;

constraint abs(Z - Y) <= max_diff_ZY;

constraint total_support = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_support;