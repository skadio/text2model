% Portfolio allocation MILP (all amounts in whole dollars)
% Minimize total management cost subject to budget and linear constraints.

include "globals.mzn";

% Decision variables (integer dollars)
var 10000..60000: x1;
var 20000..80000: x2;
var 15000..50000: x3;
var 200..100000:  x4;   % no stated upper bound; limited by total budget

% Total budget
constraint x1 + x2 + x3 + x4 <= 100000;

% 0.60*x1 - 0.40*x2 >= 0  ==>  3*x1 - 2*x2 >= 0
constraint 3 * x1 - 2 * x2 >= 0;

% (x3 + x4) should not be less than (x1 + x2) by more than 30000:
% (x1+x2) - (x3+x4) <= 30000
constraint (x1 + x2) - (x3 + x4) <= 30000;

% 0.70*x3 - 0.50*x4 <= 500  ==>  7*x3 - 5*x4 <= 5000
constraint 7 * x3 - 5 * x4 <= 5000;

% Objective: minimize total cost.
% Use integer "cents" to avoid floating-point in the solver:
% 0.05,0.08,0.12,0.15 dollars per dollar invested -> 5,8,12,15 cents.
var int: total_cost_cents = 5*x1 + 8*x2 + 12*x3 + 15*x4;

solve minimize total_cost_cents;

output [
  "x1 = $", show(x1), "\n",
  "x2 = $", show(x2), "\n",
  "x3 = $", show(x3), "\n",
  "x4 = $", show(x4), "\n",
  "Total investment = $", show(x1+x2+x3+x4), "\n",
  "Minimum total cost = $",
  show(total_cost_cents div 100), ".",
  if (total_cost_cents mod 100) < 10 then "0" else "" endif,
  show(total_cost_cents mod 100),
  "\n"
];