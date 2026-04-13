% Telecom resource allocation optimization
% All data embedded as requested.

include "globals.mzn";

% Decision variables (integer whole units)
var 0..1000: x1;  % Project X1
var 0..1200: x2;  % Project X2
var 0..800:  x3;  % Project X3
var 0..700:  x4;  % Project X4

% Constraints
constraint x1 + x2 <= 2000;
constraint x3 + x4 <= 1500;

% "half of x1 should exceed by at least 500 units than one-third of x2"
% 0.5*x1 >= (1/3)*x2 + 500  -> multiply by 6: 3*x1 >= 2*x2 + 3000
constraint 3 * x1 >= 2 * x2 + 3000;

% x4 at least 100 more than x3
constraint x4 >= x3 + 100;

% Objective: minimize total cost
var int: total_cost = 50*x1 + 30*x2 + 70*x3 + 60*x4;
solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];