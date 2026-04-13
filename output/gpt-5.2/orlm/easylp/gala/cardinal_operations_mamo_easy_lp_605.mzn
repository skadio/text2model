include "globals.mzn";

% Decision variables: annual budget allocations (integers)
% Upper bounds are not explicitly provided, so use safe bounds implied by constraints.
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..2000: x4;  % can be larger since only linked via ratios; bounded by x1>=0.7x4 and x1<=1000

% Constraints
constraint x1 + x2 <= 1000;
constraint x2 + x3 >= 500;

% x3 - 0.5*x4 <= 200  ->  2*x3 - x4 <= 400
constraint 2*x3 - x4 <= 400;

% x1 >= 0.7*x4  ->  10*x1 >= 7*x4
constraint 10*x1 >= 7*x4;

% 0.8*x2 + x3 - x1 <= 70  ->  4*x2 + 5*x3 - 5*x1 <= 350
constraint 4*x2 + 5*x3 - 5*x1 <= 350;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "total_cost = ", show(total_cost), "\n"
];