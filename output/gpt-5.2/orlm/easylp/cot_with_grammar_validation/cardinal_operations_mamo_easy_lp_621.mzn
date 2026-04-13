% Parameters
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

int: cap12 = 1000;
int: cap34 = 1200;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% x1 >= (4/3) * x3  <=>  3*x1 >= 4*x3
constraint 3 * x1 >= 4 * x3;

% x2 >= (9/7) * x4 + 200  <=>  7*x2 >= 9*x4 + 1400
constraint 7 * x2 >= 9 * x4 + 1400;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;