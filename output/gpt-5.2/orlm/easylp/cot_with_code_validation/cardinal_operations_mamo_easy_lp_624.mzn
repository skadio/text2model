% Parameters
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

int: cap12 = 1000;
int: cap34 = 1200;

% To avoid fractions: 0.7*x1 - 0.8*x2 >= 200  <=>  7*x1 - 8*x2 >= 2000
int: rhs_balance = 2000;

int: min_diff_43 = 300;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Objective value scaled by 10 to keep it integer:
% cost = 1.5*x1 + 2*x2 + 3*x3 + 4*x4
% 10*cost = 15*x1 + 20*x2 + 30*x3 + 40*x4
var 0..(15*cap12 + 20*cap12 + 30*cap34 + 40*cap34): cost10;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 7*x1 - 8*x2 >= rhs_balance;
constraint x4 - x3 >= min_diff_43;

constraint cost10 = 15*x1 + 20*x2 + 30*x3 + 40*x4;

% Objective
solve minimize cost10;