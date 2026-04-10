include "globals.mzn";

% Data (embedded from problem description)
int: BUDGET = 1000;
int: min_service = 200;          % 2*X - Y >= 200
int: max_diff_yz = 50;           % |Y - Z| <= 50

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Resource allocations (whole numbers)
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint 2*X - Y >= min_service;
constraint abs(Y - Z) <= max_diff_yz;

% Objective: minimize total cost
var 0..costZ*BUDGET: total_cost;
constraint total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];