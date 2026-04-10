% Telecommunications resource allocation (integer linear optimization)
include "globals.mzn";

% Decision variables: whole-number resource units allocated to each project
% Bounds: not specified beyond being nonnegative, so use a safe upper bound
int: UB = 100000;

var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;

% Constraints
constraint X1 + 2 * X2 <= 2000;
constraint 3 * X1 + 4 * X3 >= 1000;
constraint X2 - 5 * X3 <= 500;

% Objective: minimize total cost
var int: total_cost = 10 * X1 + 20 * X2 + 30 * X3;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];