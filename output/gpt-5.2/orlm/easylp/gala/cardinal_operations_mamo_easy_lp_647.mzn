include "globals.mzn";

% Decision variables: integer resource allocations
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Costs
int: c1 = 300;
int: c2 = 200;
int: c3 = 500;
int: c4 = 400;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x1 + x3 >= 800;
constraint 2*x2 - x4 >= 600;                 % x2 - 0.5*x4 >= 300  ->  2*x2 - x4 >= 600
constraint x2 - x3 - x1 <= 70;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];