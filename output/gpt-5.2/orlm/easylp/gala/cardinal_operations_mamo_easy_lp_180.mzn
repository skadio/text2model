% Energy resource allocation (integer linear optimization)
include "globals.mzn";

% Decision variables: integer resource units allocated to each project
var 0..1000: x;  % Project X
var 0..1000: y;  % Project Y
var 0..1000: z;  % Project Z

% Constraints
constraint x + y + z <= 1000;
constraint 2*x + y >= 500;
constraint x + 2*z <= 600;

% Objective: minimize total cost
var int: total_cost = 6*x + 3*y + 5*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];