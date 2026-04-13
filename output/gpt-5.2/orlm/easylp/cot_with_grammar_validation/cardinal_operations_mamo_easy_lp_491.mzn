% Parameters
int: support_x = 1000;
int: support_y = 2000;

int: a1_x = 5;
int: a1_y = 10;
int: rhs1 = 50000;

int: a2_x = 3;
int: a2_y = 4;
int: rhs2 = 30000;

int: diff_min = 1000;

% Variable bounds derived from constraints:
% From 3x + 4y <= 30000 and x,y >= 0:
% x <= 10000, y <= 7500
int: x_ub = 10000;
int: y_ub = 7500;

% Variables
var 0..x_ub: x;
var 0..y_ub: y;
var 0..(support_x * x_ub + support_y * y_ub): total_support;

% Constraints
constraint total_support = support_x * x + support_y * y;

constraint a1_x * x + a1_y * y >= rhs1;
constraint a2_x * x + a2_y * y <= rhs2;
constraint x - y >= diff_min;

% Objective
solve minimize total_support;