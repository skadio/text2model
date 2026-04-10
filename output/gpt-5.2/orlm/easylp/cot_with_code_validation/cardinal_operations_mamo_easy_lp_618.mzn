% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max_x1x2 = 8;
int: min_2x2_plus_x3 = 10;
int: max_x3_minus_3x4 = 15;
int: x4_minus_x1_eq = 5;

% Variables
var 0..100: x1;
var 0..100: x2;
var 0..100: x3;
var 0..100: x4;

var 0..10000: total_fatigue;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint 2*x2 + x3 >= min_2x2_plus_x3;
constraint x3 - 3*x4 <= max_x3_minus_3x4;
constraint x4 - x1 = x4_minus_x1_eq;

% Objective
constraint total_fatigue = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_fatigue;