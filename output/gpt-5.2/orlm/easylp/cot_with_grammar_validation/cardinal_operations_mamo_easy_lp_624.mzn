% Parameters
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

int: cap12 = 1000;
int: cap34 = 1200;

int: rhs_diff12 = 200;
int: rhs_diff43 = 300;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var float: total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% 0.7*x1 - 0.8*x2 >= 200  <=>  7*x1 - 8*x2 >= 2000
constraint 7 * x1 - 8 * x2 >= 10 * rhs_diff12;

constraint x4 - x3 >= rhs_diff43;

constraint total_cost = c1*int2float(x1) + c2*int2float(x2) + c3*int2float(x3) + c4*int2float(x4);

% Objective
solve minimize total_cost;