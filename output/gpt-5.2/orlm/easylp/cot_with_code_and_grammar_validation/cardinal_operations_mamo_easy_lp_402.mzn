% Parameters
int: max_x1_x2 = 1000;
int: min_2x1_x3 = 800;
int: max_x2_3x4 = 600;
int: min_x1_halfx4 = 200;

int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Variables
var 0..1000: x1;
var 0..1000: x2;
var 0..800: x3;
var 0..200: x4;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint 2*x1 + x3 >= min_2x1_x3;
constraint x2 + 3*x4 <= max_x2_3x4;
constraint 2*x1 - x4 >= 2*min_x1_halfx4;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;