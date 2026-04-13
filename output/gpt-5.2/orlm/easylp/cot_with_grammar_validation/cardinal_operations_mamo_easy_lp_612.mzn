% Parameters
int: max_x1_x2 = 1000;
int: min_2x3_3x4 = 500;
int: max_diff_x1_x4 = 200;

int: c1 = 50;
int: c2 = 30;
int: c3 = 20;
int: c4 = 10;

% Variables
var 0..max_x1_x2: x1;
var 0..max_x1_x2: x2;
var 0..max_x1_x2: x3;
var 0..max_x1_x2: x4;

var 0..(c1*max_x1_x2 + c2*max_x1_x2 + c3*max_x1_x2 + c4*max_x1_x2): total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;

constraint 2*x3 + 3*x4 >= min_2x3_3x4;

constraint abs(x1 - x4) <= max_diff_x1_x4;

constraint x3 >= 2*x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;