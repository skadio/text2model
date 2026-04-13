% Parameters
int: max_total_units = 1000;
int: min_strength = 500;

int: x_min = 0;
int: x_max = 700;
int: y_min = 0;
int: y_max = 400;

int: support_x = 500;
int: support_y = 300;

% Variables
var x_min..x_max: X;
var y_min..y_max: Y;

var 0..(support_x*x_max + support_y*y_max): total_support;

% Constraints
constraint X + Y <= max_total_units;
constraint 2*X + Y >= min_strength;

constraint total_support = support_x*X + support_y*Y;

% Objective
solve minimize total_support;