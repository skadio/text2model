include "globals.mzn";

% Decision variables (nonnegative integers)
var 0..1000: x;   % number of X programs
var 0..1000: y;   % number of Y programs

% Constraints
constraint x + y >= 30;
constraint abs(2*x - y) <= 10;

% Objective: minimize total cost
var 0..100000: cost = 4*x + 3*y;

solve minimize cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_cost = ", show(cost), "\n"
];