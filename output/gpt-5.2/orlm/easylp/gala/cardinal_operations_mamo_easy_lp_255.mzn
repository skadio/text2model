% Supply chain resource allocation (integer optimization)
% All data embedded as requested.

include "globals.mzn";

% Decision variables (integer allocations)
var 0..100: x1;   % bounds chosen to reflect stated upper limit and typical capacity
var 0..100: x2;   % bounds chosen to reflect stated upper limit and typical capacity
var 0..200: x3;   % allow more flexibility for x3 given it appears with coefficient 3

% Constraints
constraint x1 + x2 <= 100;
constraint 2*x1 + 3*x3 >= 150;
constraint 4*x2 - x3 <= 200;

% Objective: minimize total cost
var int: total_cost = 5*x1 + 4*x2 + 6*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];