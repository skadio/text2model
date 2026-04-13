% Fleet allocation / integer linear minimization
% All data embedded as requested.

include "globals.mzn";

% Decision variables: vehicles allocated to each route (integers, nonnegative)
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;
var 0..10000: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 400;
constraint x1 + x3 >= 300;
constraint x2 + x4 >= 600;

% Objective: minimize total operating cost
var int: total_cost = 10*x1 + 9*x2 + 11*x3 + 12*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];