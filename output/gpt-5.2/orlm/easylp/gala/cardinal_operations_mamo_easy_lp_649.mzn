include "globals.mzn";

% Data (embedded as requested)
int: c1 = 5;
int: c2 = 6;
int: c3 = 7;
int: c4 = 8;

% Decision variables: whole number shipments
var 0..1000: x1;
var 0..1000: x2;
var 0..800:  x3;
var 0..800:  x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 800;

% x1 - 0.5*x3 >= 200  ->  2*x1 - x3 >= 400
constraint 2*x1 - x3 >= 400;

% 0.25*x4 - x2 >= 150 -> x4 - 4*x2 >= 600
constraint x4 - 4*x2 >= 600;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];