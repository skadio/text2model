% Production planning MILP (integer variables)
% Data embedded as requested.

include "globals.mzn";

% Decision variables: integer units produced
var 0..500: X;
var 0..500: Y;
var 0..500: Z;

% Constraints
constraint X + Y + Z <= 500;
constraint 3*X - Y + Z >= 100;
constraint X - 2*Y - Z <= 200;

% Objective: minimize total cost
var int: total_cost = 50*X + 30*Y + 20*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];