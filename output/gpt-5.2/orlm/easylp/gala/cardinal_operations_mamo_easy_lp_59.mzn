% Resource allocation (integer linear optimization)

include "globals.mzn";

% Decision variables (whole numbers)
var 0..100: X; % Network Upgrade units
var 0..100: Y; % Security Enhancement units

% Constraints
constraint 3*X + Y >= 10;
constraint 2*X + 4*Y <= 20;

% Objective: minimize total cost
var int: total_cost = 4*X + 6*Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];