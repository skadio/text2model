% Parameters
float: c1 = 0.5;
float: c2 = 0.3;
float: c3 = 0.4;
float: c4 = 0.6;

int: x1_lb = 0;
int: x1_ub = 2000;
int: x2_lb = 0;
int: x2_ub = 1500;
int: x3_lb = 500;
int: x3_ub = 1500;
int: x4_lb = 500;
int: x4_ub = 2000;

int: cap12 = 5000;
int: diff23 = 1000;
int: cap34 = 3000;
int: diff41 = 100;

% Variables
var x1_lb..x1_ub: X1;
var x2_lb..x2_ub: X2;
var x3_lb..x3_ub: X3;
var x4_lb..x4_ub: X4;

var float: total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint X2 >= X3 + diff23;
constraint X3 + 2 * X4 <= cap34;
constraint X4 >= X1 + diff41;

constraint total_cost = c1 * int2float(X1) + c2 * int2float(X2) + c3 * int2float(X3) + c4 * int2float(X4);

% Objective
solve minimize total_cost;