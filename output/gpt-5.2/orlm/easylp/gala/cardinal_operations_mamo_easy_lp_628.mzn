include "globals.mzn";

% Decision variables: number of employees in each department (integers)
var 0..50: x1;
var 0..60: x2;
var 0..40: x3;
var 0..40: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 <= 80;

% x1 must be at least 20 more than half of x3:
% x1 >= 20 + x3/2  <=>  2*x1 >= 40 + x3
constraint 2 * x1 >= 40 + x3;

% Difference between x4 and x2 should not exceed 30: |x4 - x2| <= 30
constraint abs(x4 - x2) <= 30;

% Objective: minimize total monthly salary cost
var int: total_cost = 5000 * x1 + 4000 * x2 + 6000 * x3 + 7000 * x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_monthly_salary = ", show(total_cost), "\n"
];