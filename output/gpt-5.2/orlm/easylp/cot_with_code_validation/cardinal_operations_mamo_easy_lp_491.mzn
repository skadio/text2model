% Parameters
int: support_x = 1000;
int: support_y = 2000;

int: strength_x = 5;
int: strength_y = 10;
int: min_strength = 50000;

int: cap_x = 3;
int: cap_y = 4;
int: max_cap = 30000;

int: min_diff = 1000;

% Variable bounds (chosen sufficiently large from constraints)
int: x_ub = max_cap div cap_x; % since 3*x + 4*y <= 30000 and y>=0
int: y_ub = max_cap div cap_y;

% Variables
var 0..x_ub: x;
var 0..y_ub: y;
var 0..(support_x * x_ub + support_y * y_ub): total_support;

% Constraints
constraint strength_x * x + strength_y * y >= min_strength;
constraint cap_x * x + cap_y * y <= max_cap;
constraint x - y >= min_diff;

constraint total_support = support_x * x + support_y * y;

% Objective
solve minimize total_support;