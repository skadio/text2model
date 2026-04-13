% Parameters
float: c1 = 0.5;
float: c2 = 0.6;
float: c3 = 0.8;
float: c4 = 1.2;

int: cap12 = 300;
int: cap34 = 500;

int: rhs3 = 100;
int: rhs4 = 200;

% Variables
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Objective uses scaled integer to avoid floating arithmetic:
% minimize (0.5,0.6,0.8,1.2) dot (x1..x4)  <=>  minimize (5,6,8,12) dot (x1..x4) / 10
var 0..(12*(cap12+cap12+cap34+cap34)): cost10;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% 0.7*x2 - x1 - x3 + 0.9*x4 >= 100
% Multiply by 10: 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000
constraint 7*x2 - 10*x1 - 10*x3 + 9*x4 >= 10*rhs3;

% (x3 - 0.8*x4) - (x1 + x2) <= 200
% Multiply by 10: 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000
constraint 10*x3 - 8*x4 - 10*x1 - 10*x2 <= 10*rhs4;

constraint cost10 = 5*x1 + 6*x2 + 8*x3 + 12*x4;

% Objective
solve minimize cost10;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_cost=", show(fix(cost10) / 10.0), "\n"
];