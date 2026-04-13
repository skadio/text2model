% Parameters
int: support_X = 5000;
int: support_Y = 3000;
int: min_units = 50;
int: strength_X = 5;
int: strength_Y = 3;
int: max_strength = 200;

% Variables
var 0..(max_strength div strength_X): X;
var 0..(max_strength div strength_Y): Y;
var 0..(support_X*(max_strength div strength_X) + support_Y*(max_strength div strength_Y)): total_support;

% Constraints
constraint X + Y >= min_units;
constraint strength_X * X + strength_Y * Y <= max_strength;
constraint total_support = support_X * X + support_Y * Y;

% Objective
solve minimize total_support;