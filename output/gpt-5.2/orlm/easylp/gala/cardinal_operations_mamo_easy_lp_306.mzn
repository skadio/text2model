include "globals.mzn";

% Decision variables: fund allocations (whole numbers)
var 0..50: X;         % Project X max 50
var 0..40: Y;         % Project Y max 40
var 0..100: Z;        % Project Z (no stated upper bound, but implied by total budget)

% Constraints
constraint X + Y + Z <= 100;
constraint 2 * X - Y >= 20;
constraint Y + Z <= 70;

% Objective: minimize total cost
var int: total_cost = 2 * X + 3 * Y + 4 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];