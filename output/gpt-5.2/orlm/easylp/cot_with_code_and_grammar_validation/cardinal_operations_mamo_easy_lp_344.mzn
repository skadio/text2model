% Parameters
int: cap12 = 1000;
int: cap34 = 500;

float: r1 = 0.05;
float: r2 = 0.07;
float: min_ret12 = 50.0;

float: l3 = -0.03;
float: l4 = -0.04;
float: max_loss34 = -20.0;

int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% Variables
var 0..cap12: X1;
var 0..cap12: X2;
var 0..cap34: X3;
var 0..cap34: X4;

var 0..(c1*cap12 + c2*cap12 + c3*cap34 + c4*cap34): TotalCost;

% Constraints
constraint X1 + X2 <= cap12;
constraint r1 * int2float(X1) + r2 * int2float(X2) >= min_ret12;

constraint X3 + X4 <= cap34;
constraint l3 * int2float(X3) + l4 * int2float(X4) <= max_loss34;

constraint TotalCost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize TotalCost;