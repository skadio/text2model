include "globals.mzn";

% Fund allocations (whole numbers)
var 0..100000: X1;
var 0..100000: X2;
var 0..100000: X3;
var 0..100000: X4;

% Constraints
constraint X1 + X2 <= 2000;
constraint 2*X3 + 3*X4 >= 3000;
constraint abs(X1 - X4) <= 500;
constraint X2 >= X3 + 1000;

% Objective: minimize total expenditure
var int: total_cost = 2*X1 + 3*X2 + 4*X3 + 5*X4;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "Minimum total expenditure (rounded) = ", show(total_cost), "\n"
];