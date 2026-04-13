% Resource allocation / integer linear minimization (all data embedded)

include "globals.mzn";

% Decision variables: integer units of resource allocated to each project
var 0..10: x1;
var 0..10: x2;
var 0..10: x3;

% Constraints
constraint x1 + x2 + x3 <= 10;
constraint 5*x1 + 4*x2 >= 30;
constraint 7*x1 - 6*x3 <= 20;
constraint x2 - (x1 + x3) >= 0;

% Objective: minimize total cost
var int: total_cost = 500*x1 + 700*x2 + 900*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];