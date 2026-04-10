include "globals.mzn";

/*
  Retail resource allocation LP (all data embedded).

  Decision variables: resource allocations for departments
    x1 = electronics, x2 = clothing, x3 = groceries, x4 = home goods

  Objective: minimize total cost 5*x1 + 3*x2 + 2*x3 + 7*x4

  Constraints:
    2*x1 + 3*x2 <= 150
    x1 + x4 >= 30
    |x3 - x4| <= 10
    4*x1 + 5*x2 + x3 >= 80
*/

% Since no explicit bounds are provided in the prompt, we assume nonnegative allocations.
% Add conservative upper bounds to keep the model bounded and well-defined.
int: UB = 1000;

var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

constraint 2*x1 + 3*x2 <= 150;
constraint x1 + x4 >= 30;
constraint abs(x3 - x4) <= 10;
constraint 4*x1 + 5*x2 + x3 >= 80;

var int: total_cost = 5*x1 + 3*x2 + 2*x3 + 7*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];