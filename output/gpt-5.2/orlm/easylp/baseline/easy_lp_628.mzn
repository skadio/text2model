% Employee allocation / cost minimization

int: salary1 = 5000;
int: salary2 = 4000;
int: salary3 = 6000;
int: salary4 = 7000;

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

% The difference between x4 and x2 should not exceed 30:
constraint abs(x4 - x2) <= 30;

% Objective
var int: total_cost = salary1*x1 + salary2*x2 + salary3*x3 + salary4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_monthly_salary=", show(total_cost), "\n"
];