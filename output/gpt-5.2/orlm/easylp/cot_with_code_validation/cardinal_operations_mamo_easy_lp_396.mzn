% Parameters
int: max_x1x2 = 1000;
int: min_2x3x4 = 500;
int: max_x1_3x4 = 1200;
int: max_x2_minus_2x3 = 300;

int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Variables
var 0..1200: x1;
var 0..1000: x2;
var 0..600: x3;
var 0..600: x4;

var 0..10000000: total_cost;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint 2*x3 + x4 >= min_2x3x4;
constraint x1 + 3*x4 <= max_x1_3x4;
constraint x2 - 2*x3 <= max_x2_minus_2x3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;