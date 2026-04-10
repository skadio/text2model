% Parameters (with values embedded)
int: max_total_units = 1000;
int: min_strength_requirement = 500; % for 2*X + 1*Y
int: support_per_X = 500;
int: support_per_Y = 300;

int: X_lb = 0;
int: X_ub = 700;
int: Y_lb = 0;
int: Y_ub = 400;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var 0..(support_per_X*X_ub + support_per_Y*Y_ub): total_support;

% Constraints
constraint X + Y <= max_total_units;
constraint 2*X + Y >= min_strength_requirement;
constraint total_support = support_per_X*X + support_per_Y*Y;

% Objective
solve minimize total_support;