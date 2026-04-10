include "globals.mzn";

% Decision variables: resource allocations (whole units)
var 0..10000: x;  % project X units
var 0..10000: y;  % project Y units
var 0..10000: z;  % project Z units

% Constraints
constraint x + y + z <= 10000;
constraint 2*x + 3*y + z >= 5000;
constraint x - y + z <= 3000;

% Objective: minimize total cost ($)
var int: total_cost = 10*x + 20*y + 30*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];