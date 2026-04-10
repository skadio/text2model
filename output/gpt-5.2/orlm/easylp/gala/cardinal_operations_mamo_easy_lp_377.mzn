% Employee allocation across 4 departments with minimum salary cost

include "globals.mzn";

% Costs per employee
int: c1 = 50;
int: c2 = 40;
int: c3 = 30;
int: c4 = 20;

% Decision variables: number of employees in each department (nonnegative integers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Constraints
constraint x1 + x2 >= 15;
constraint x2 + x3 <= 25;
constraint x3 - x4 >= 5;
constraint abs(x1 - 2*x4) <= 10;

% Objective: minimize total salary cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total salary cost = $", show(total_cost), "\n"
];