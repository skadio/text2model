% Parameters (with values embedded)
int: min_requirement = 10;          % 2*X + Y >= 10
int: max_capacity = 50;             % X + 4*Y <= 50
int: support_X = 5;                 % support points per unit X
int: support_Y = 3;                 % support points per unit Y

% Variables
var 0..50: X;
var 0..50: Y;
var 0..1000: total_support;

% Constraints
constraint 2*X + Y >= min_requirement;
constraint X + 4*Y <= max_capacity;
constraint total_support = support_X*X + support_Y*Y;

% Objective
solve minimize total_support;