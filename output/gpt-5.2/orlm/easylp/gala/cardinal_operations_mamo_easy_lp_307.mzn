include "globals.mzn";

% Data (embedded as required)
int: BUDGET = 1000;

int: cx = 10;
int: cy = 15;
int: cz = 20;

% Decision variables (integer allocations)
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= 2*Y + 200;
constraint Z >= Y + 100;

% Objective: minimize total cost
var int: total_cost = cx*X + cy*Y + cz*Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];