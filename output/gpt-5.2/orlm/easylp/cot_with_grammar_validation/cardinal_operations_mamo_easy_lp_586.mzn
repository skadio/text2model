% Parameters
int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

int: cap12 = 500;
int: cap34 = 600;

int: min_diff_3_vs_12 = 100;  % X3 - (X1+X2) >= 100
int: min_diff_4_vs_2  = 50;   % X4 - X2 >= 50

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

constraint x3 - (x1 + x2) >= min_diff_3_vs_12;
constraint x4 - x2 >= min_diff_4_vs_2;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;