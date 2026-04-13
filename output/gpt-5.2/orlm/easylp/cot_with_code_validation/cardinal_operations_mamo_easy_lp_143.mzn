% Parameters
int: min_req = 10;          % 2*X + Y >= 10
int: max_cap = 50;          % X + 4*Y <= 50
int: support_x = 5;         % support points per unit X
int: support_y = 3;         % support points per unit Y

% Variables
var 0..max_cap: X;
var 0..max_cap: Y;
var 0..(support_x*max_cap + support_y*max_cap): total_support;

% Constraints
constraint 2*X + Y >= min_req;
constraint X + 4*Y <= max_cap;

constraint total_support = support_x*X + support_y*Y;

% Objective
solve minimize total_support;