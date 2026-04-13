% Parameters
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

int: cap12 = 1000;
int: cap34 = 1200;

% To avoid floats in constraints:
% 0.7*x1 - 0.8*x2 >= 200  <=>  7*x1 - 8*x2 >= 2000
int: rhs_bal = 2000;

int: diff43 = 300;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Cost scaled by 2 to keep objective integer:
% min floor(1.5x1 + 2x2 + 3x3 + 4x4) is equivalent to min (3x1 + 4x2 + 6x3 + 8x4)
var 0..(3*cap12 + 4*cap12 + 6*cap34 + 8*cap34): cost2;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint 7*x1 - 8*x2 >= rhs_bal;
constraint x4 - x3 >= diff43;

constraint cost2 = 3*x1 + 4*x2 + 6*x3 + 8*x4;

% Objective
solve minimize cost2;