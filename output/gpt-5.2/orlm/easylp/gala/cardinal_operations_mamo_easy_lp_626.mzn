include "globals.mzn";

% Decision variables: whole-number allocations (nonnegative integers).
% Upper bounds come from the pairwise budget limits.
var 0..50: X1;
var 0..50: X2;
var 0..70: X3;
var 0..70: X4;

% Constraints
constraint X1 + X2 <= 50;
constraint X3 + X4 <= 70;
constraint X1 - 2*X3 >= 10;
constraint X2 - 2*X4 <= 20;

% Costs per unit (in dollars)
int: c1 = 5000;
int: c2 = 6000;
int: c3 = 7000;
int: c4 = 8000;

var int: total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];