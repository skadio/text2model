% Parameters
int: c1 = 100;
int: c2 = 50;
int: c3 = 30;
int: c4 = 200;

% Variable bounds (not specified explicitly in the description, so use non-negative integers)
int: UB = 1000000;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

var 0..(c1*UB + c2*UB + c3*UB + c4*UB): total_cost;

% Constraints
constraint x1 + x2 >= 10;
constraint x3 + x4 >= 20;
constraint 5*x1 - 2*x2 <= 0;
constraint 3*x3 - x4 >= 0;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;