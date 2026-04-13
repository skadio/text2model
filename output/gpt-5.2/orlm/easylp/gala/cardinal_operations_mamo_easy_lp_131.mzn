include "globals.mzn";

% Budgets (integers, dollars)
var 0..10000: x;   % budget for project X
var 0..10000: y;   % budget for project Y

% Constraints
constraint x + y <= 10000;                 % total budget cap
constraint 10*x + 4*y >= 40000;            % required combined impact score

% Objective: minimize total cost/points-per-dollar (given as 50 and 30)
var 0..(50*10000 + 30*10000): total_cost = 50*x + 30*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];