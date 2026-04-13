% Parameters
int: max_total_units = 1000;
int: min_strength = 500;

int: x_support = 500;
int: y_support = 300;

int: x_lb = 0;
int: x_ub = 700;
int: y_lb = 0;
int: y_ub = 400;

% Variables
var x_lb..x_ub: X;
var y_lb..y_ub: Y;
var 0..(x_support * x_ub + y_support * y_ub): total_support;

% Constraints
constraint X + Y <= max_total_units;
constraint 2 * X + Y >= min_strength;
constraint total_support = x_support * X + y_support * Y;

% Objective
solve minimize total_support;