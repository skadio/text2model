include "globals.mzn";

% Data (embedded from problem statement)
int: budget = 1000;
int: maxX = 700;
int: maxY = 500;
int: costX = 50;
int: costY = 30;

% Decision variables (integer allocations)
var 0..maxX: X;
var 0..maxY: Y;

% Constraints
constraint X + Y <= budget;
constraint 3 * X - 2 * Y >= 0;
constraint X - Y >= 200;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];