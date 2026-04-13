include "globals.mzn";

% Decision variables (whole-number resource allocations)
var 0..800: x1;
var 0..700: x2;
var 0..500: x3;
var 0..200: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x3 + 3*x4 <= 1500;

% x1 should exceed half of x3 by at least 300 units:
% x1 >= 0.5*x3 + 300  <=>  2*x1 >= x3 + 600
constraint 2*x1 >= x3 + 600;

% Difference between x4 and x2 should not surpass 400 units
constraint abs(x4 - x2) <= 400;

% Objective: minimize total cost
var int: total_cost = 50*x1 + 60*x2 + 30*x3 + 20*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];