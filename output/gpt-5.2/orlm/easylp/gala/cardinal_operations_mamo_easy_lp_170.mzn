% Marketing budget allocation (integer units) minimizing total cost
include "globals.mzn";

% Decision variables: integer "units of effectiveness" purchased in each channel
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints (budgets / requirements)
constraint X + Y <= 1000;
constraint Y + Z <= 800;
constraint X + Z >= 500;

% Total cost in dollars
var 0..10000000: total_cost = 5*X + 4*Y + 3*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];