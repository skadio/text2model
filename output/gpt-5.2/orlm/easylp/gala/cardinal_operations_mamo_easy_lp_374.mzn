% Supply chain resource allocation (integer linear optimization)

include "globals.mzn";

% Decision variables (all allocations are whole numbers)
var 0..100:  x1;
var 0..200:  x2;
var 0..150:  x3;
var -100..300: x4;

% Constraints
constraint x1 + x2 <= 150;
constraint x3 >= x4 + 30;

% 0.5*x1 - 0.75*x4 <= 20  -> multiply by 4: 2*x1 - 3*x4 <= 80
constraint 2*x1 - 3*x4 <= 80;

% x2 - 0.25*x3 >= -50 -> multiply by 4: 4*x2 - x3 >= -200
constraint 4*x2 - x3 >= -200;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 5*x3 + 7*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];