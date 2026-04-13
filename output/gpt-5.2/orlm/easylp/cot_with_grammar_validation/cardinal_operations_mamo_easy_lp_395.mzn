% Parameters
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;
int: c4 = 40;

int: max_x1x2 = 50;
int: min_x3_minus_x4 = 10;
int: max_2x1_plus_x3 = 60;
int: min_x2_minus_2x4 = 5;

% Variables
var 0..max_x1x2: x1;
var 0..max_x1x2: x2;
var 0..max_2x1_plus_x3: x3;
var 0..max_2x1_plus_x3: x4;

var 0..(c1*max_x1x2 + c2*max_x1x2 + c3*max_2x1_plus_x3 + c4*max_2x1_plus_x3): total_cost;

% Constraints
constraint x1 + x2 <= max_x1x2;

constraint x3 >= x4 + min_x3_minus_x4;

constraint 2*x1 + x3 <= max_2x1_plus_x3;

constraint x2 >= 2*x4 + min_x2_minus_2x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;