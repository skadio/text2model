% Transportation fleet allocation (integer linear optimization)
% Data embedded as requested.

include "globals.mzn";

% Decision variables: number of vehicles assigned to each route
var 0..200: x1;
var 0..200: x2;
var 0..200: x3;
var 0..200: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint x3 + x4 <= 200;
constraint x1 + x3 >= 50;
constraint x2 + x4 >= 150;

% Objective: minimize total cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3 + 5*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];