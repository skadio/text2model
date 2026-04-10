include "globals.mzn";

% Decision variables: number of people in each tour package (nonnegative integers)
var 0..500: x1;  % from x1 + x2 <= 500
var 0..500: x2;
var 0..700: x3;  % from x3 + x4 <= 700
var 0..700: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 700;
constraint x1 + x3 >= 200;
constraint x2 + x4 >= 300;

% Objective: minimize total cost
var int: total_cost = 100*x1 + 200*x2 + 300*x3 + 400*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];