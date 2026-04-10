include "globals.mzn";

% Data (embedded from problem statement)
int: c1 = 50;
int: c2 = 75;
int: c3 = 100;
int: c4 = 125;

int: cap12 = 5000;   % x1 + x2 <= 5000
int: cap34 = 3000;   % x3 + x4 <= 3000

int: min13 = 2000;   % x1 + x3 >= 2000
int: min24 = 4000;   % x2 + x4 >= 4000

% Decision variables: integer resource allocations
var 0..cap12: x1;
var 0..cap12: x2;
var 0..cap34: x3;
var 0..cap34: x4;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

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