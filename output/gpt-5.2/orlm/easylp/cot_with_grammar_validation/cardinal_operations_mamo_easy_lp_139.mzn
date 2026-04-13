% Parameters
int: total_units_limit = 1000;
int: strength_min = 500;

int: x_support = 500;
int: y_support = 300;

int: x_lb = 0;
int: x_ub = 700;
int: y_lb = 0;
int: y_ub = 400;

% Variables
var x_lb..x_ub: X;
var y_lb..y_ub: Y;
var 0..(x_ub * x_support + y_ub * y_support): total_support;

% Constraints
constraint X + Y <= total_units_limit;
constraint 2 * X + 1 * Y >= strength_min;

constraint total_support = x_support * X + y_support * Y;

% Objective
solve minimize total_support;