% Military logistics resource allocation (integer optimization)

include "globals.mzn";

% Decision variables (integer allocations)
var 0..300: x1;
var 0..250: x2;
var 0..400: x3;
var 0..350: x4;

% Constraints
constraint x1 + x2 >= 200;
constraint abs(x3 - x4) <= 50;

% 2*x2 - x1 - 0.5*x3 <= 100  ==>  4*x2 - 2*x1 - x3 <= 200 (integer form)
constraint 4*x2 - 2*x1 - x3 <= 200;

% (3/4)*x1 = x4 + 150  ==>  3*x1 = 4*x4 + 600 (integer form)
constraint 3*x1 = 4*x4 + 600;

constraint x1 + x2 + x3 + x4 <= 500;

% Objective: minimize total cost
var int: total_cost = 10*x1 + 15*x2 + 20*x3 + 25*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];