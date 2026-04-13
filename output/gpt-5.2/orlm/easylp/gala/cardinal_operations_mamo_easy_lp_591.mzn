include "globals.mzn";

% Data (embedded as required)
int: maxX1 = 600;
int: maxX2 = 400;
int: maxX3 = 500;
int: maxX4 = 300;

int: c1 = 50;
int: c2 = 60;
int: c3 = 70;
int: c4 = 80;

% Decision variables (integer production quantities)
var 0..maxX1: x1;
var 0..maxX2: x2;
var 0..maxX3: x3;
var 0..maxX4: x4;

% Constraints
constraint x1 + x2 <= 1000;
constraint 2*x3 + 3*x4 <= 1200;
constraint x1 + x2 + x3 + x4 >= 500;

% x1 exceeds half of x3  =>  x1 > x3/2  <=>  2*x1 > x3
constraint 2*x1 > x3;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];