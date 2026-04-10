include "globals.mzn";

% Projects: X1, X2, X3, X4
% Unit costs in dollars
int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

% Decision variables (whole-number investments)
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;
var 0..10000: x4;

% Budget constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 600;

% Policy/strategic constraints
constraint x3 - (x1 + x2) >= 100;   % x3 at least 100 more than x1+x2
constraint x4 >= x2 + 50;           % x4 at least 50 more than x2

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];