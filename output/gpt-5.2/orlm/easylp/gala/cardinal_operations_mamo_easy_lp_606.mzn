% Retail store resource allocation (integer linear optimization)
include "globals.mzn";

% Decision variables: resource allocations (must be whole numbers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 >= 500;

% "Twice x1 should not fall short of half x3 by less than 300":
% interpret as 2*x1 is at least (x3/2) - 300, avoid fractions by multiplying by 2:
constraint 4*x1 >= x3 - 600;

% Balance constraint
constraint x1 + x2 - x4 <= 400;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "min_total_cost = ", show(total_cost), "\n"
];