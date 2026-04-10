% Parameters (with values embedded)
int: support_X = 5000;
int: support_Y = 3000;
int: min_units_total = 50;
int: strength_limit = 200;

% Variables
var 0..50: X;
var 0..50: Y;

% Constraints
constraint X + Y >= min_units_total;
constraint 5*X + 3*Y <= strength_limit;

% Objective
solve minimize support_X*X + support_Y*Y;