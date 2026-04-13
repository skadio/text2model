% Resource allocation minimization (all data embedded)

include "globals.mzn";

% Decision variables (whole-number units)
var 0..3000: x1;
var 0..2500: x2;
var 0..1500: x3;
var 0..1200: x4;

% Constraints
constraint x1 + x2 <= 5000;
constraint x3 + x4 <= 2000;

% |x1 - x2| >= 1000
constraint abs(x1 - x2) >= 1000;

% |x3 - x4| <= 500
constraint abs(x3 - x4) <= 500;

% Objective: minimize total cost
var int: total_cost = 50*x1 + 60*x2 + 30*x3 + 40*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "total_cost = ", show(total_cost), "\n"
];