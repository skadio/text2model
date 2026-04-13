% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max_x1_x2 = 1000;
int: min_2x1_3x2 = 500;

int: max_diff_x3_x1 = 200;
int: min_x4_minus_x2 = 150;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..1200: x3;
var 0..1150: x4;

var 0..(c1*1000 + c2*1000 + c3*1200 + c4*1150): total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint 2*x1 + 3*x2 >= min_2x1_3x2;

constraint x3 - x1 <= max_diff_x3_x1;
constraint x1 - x3 <= max_diff_x3_x1;

constraint x4 - x2 >= min_x4_minus_x2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;