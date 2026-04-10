include "globals.mzn";

% Decision variables: whole-number units for each project
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Nonnegativity (practical whole-number resources)
constraint x1 >= 0 /\ x2 >= 0 /\ x3 >= 0 /\ x4 >= 0;

% Constraints from the description
constraint x1 + x2 <= 50;
constraint x3 >= x4 + 10;
constraint 2 * x1 + x3 <= 60;
constraint x2 >= 2 * x4 + 5;

% Objective: minimize total cost
var int: total_cost = 10 * x1 + 20 * x2 + 30 * x3 + 40 * x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];