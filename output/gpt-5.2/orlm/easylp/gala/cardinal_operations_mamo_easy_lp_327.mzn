% Real estate development cost minimization (all data embedded)

% Decision variables: number of properties of each type (integers)
var 0..1000: X; % single-family homes
var 0..1000: Y; % multi-family homes
var 0..1000: Z; % commercial buildings

% Parameters (costs in dollars)
int: costX = 200000;
int: costY = 300000;
int: costZ = 150000;

% Constraints
constraint X + Y + Z <= 1000;

constraint X >= 400;
constraint Y >= 250;
constraint Z >= 350;

% Objective: minimize total construction cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X (single-family) = ", show(X), "\n",
  "Y (multi-family)  = ", show(Y), "\n",
  "Z (commercial)    = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];