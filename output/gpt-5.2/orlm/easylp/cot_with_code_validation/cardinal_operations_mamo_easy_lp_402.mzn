% Parameters
int: max_x1x2 = 1000;
int: min_2x1x3 = 800;
int: max_x2_3x4 = 600;
int: min_x1_minus_halfx4 = 200;

int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Variables
var 0..1000: X1;
var 0..1000: X2;
var 0..1000: X3;
var 0..1000: X4;

var 0..(c1*1000 + c2*1000 + c3*1000 + c4*1000): total_cost;

% Constraints
constraint X1 + X2 <= max_x1x2;
constraint 2*X1 + X3 >= min_2x1x3;
constraint X2 + 3*X4 <= max_x2_3x4;
constraint 2*X1 - X4 >= 2*min_x1_minus_halfx4;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;