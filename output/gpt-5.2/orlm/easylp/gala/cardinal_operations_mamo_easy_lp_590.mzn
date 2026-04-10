% Manufacturing resource allocation - integer linear optimization
include "globals.mzn";

% Costs per unit
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

% Bounds on each production line output volume
% (Not explicitly provided in the prompt; choose safe nonnegative bounds implied by constraints)
int: ub = 2000;

var 0..ub: x1;
var 0..ub: x2;
var 0..ub: x3;
var 0..ub: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x3 + 3*x4 <= 1500;

% Difference constraints
constraint x2 - (x1 + x3) >= 300;
constraint x3 - (x2 + x4) <= 500;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];