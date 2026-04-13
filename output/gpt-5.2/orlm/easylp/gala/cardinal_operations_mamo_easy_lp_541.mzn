include "globals.mzn";

% Data (embedded from problem statement)
int: max_total = 1000;
int: c1 = 500;
int: c2 = 600;
int: c3 = 700;

% Decision variables (whole-number allocations)
var 0..max_total: X1;
var 0..max_total: X2;
var 0..max_total: X3;

% Constraints
constraint X1 + X2 + X3 <= max_total;

% 2*X1 - 0.5*X2 >= 200  ->  4*X1 - X2 >= 400 (avoid fractions)
constraint 4 * X1 - X2 >= 400;

% 2*X3 - X1 <= 300
constraint 2 * X3 - X1 <= 300;

% Objective: minimize total cost
var 0..(c1*max_total + c2*max_total + c3*max_total): total_cost =
    c1 * X1 + c2 * X2 + c3 * X3;

solve minimize total_cost;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];