% Parameters (with values embedded)
int: max12 = 1000;
int: max34 = 500;

float: r1 = 0.05;
float: r2 = 0.07;
float: min_return12 = 50.0;

float: loss3 = -0.03;
float: loss4 = -0.04;
float: max_loss34 = -20.0;

int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% Variables
var 0..max12: X1;
var 0..max12: X2;
var 0..max34: X3;
var 0..max34: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 <= max12;
constraint r1 * int2float(X1) + r2 * int2float(X2) >= min_return12;

constraint X3 + X4 <= max34;
constraint loss3 * int2float(X3) + loss4 * int2float(X4) <= max_loss34;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;