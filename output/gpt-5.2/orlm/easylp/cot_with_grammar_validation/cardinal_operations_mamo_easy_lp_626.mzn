% Parameters
int: max_x1_x2 = 50;
int: max_x3_x4 = 70;
int: min_x1_minus_2x3 = 10;
int: max_x2_minus_2x4 = 20;

int: c1 = 5000;
int: c2 = 6000;
int: c3 = 7000;
int: c4 = 8000;

% Variables
var 0..max_x1_x2: x1;
var 0..max_x1_x2: x2;
var 0..max_x3_x4: x3;
var 0..max_x3_x4: x4;

var 0..(c1*max_x1_x2 + c2*max_x1_x2 + c3*max_x3_x4 + c4*max_x3_x4): total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;
constraint x1 - 2*x3 >= min_x1_minus_2x3;
constraint x2 - 2*x4 <= max_x2_minus_2x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;