include "globals.mzn";

% Data (embedded as requested)
int: c1 = 50;
int: c2 = 100;
int: c3 = 70;
int: c4 = 120;

% Decision variables: number of tours in each category (nonnegative integers)
var 0..500: x1;
var 0..500: x2;
var 0..300: x3;
var 0..300: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 300;

constraint 2*x1 + 4*x2 >= 400;
constraint 3*x3 + 2*x4 >= 250;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];