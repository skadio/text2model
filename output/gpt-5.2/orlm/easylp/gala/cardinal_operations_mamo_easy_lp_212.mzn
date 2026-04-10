% Resource allocation among departments X, Y, Z
% Minimize total cost subject to given constraints.

include "globals.mzn";

% Decision variables (whole-number allocations)
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y >= 50;
constraint X + Z <= 100;
constraint Y - Z >= 10;

% Objective: minimize total cost
var int: total_cost = 2*X + 3*Y + 1*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];