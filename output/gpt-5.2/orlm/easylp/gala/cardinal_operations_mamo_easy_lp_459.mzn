% Scheduling allocation for tasks X and Y (integer hours), minimize total cost.

include "globals.mzn";

% Decision variables (whole hours)
var 0..120: x;  % hours for task X
var 0..120: y;  % hours for task Y

% Constraints
constraint x + y >= 50;
constraint 2*x + y <= 120;
constraint x >= y;

% Objective: minimize total cost
var int: total_cost = 8*x + 10*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];