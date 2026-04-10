% Resource allocation between Project X and Project Y (integer linear optimization)

include "globals.mzn";

% Decision variables (whole-number allocations)
var 0..1000: x; % resources for Project X
var 0..1000: y; % resources for Project Y

% Constraints
constraint x + 2*y <= 100;
constraint 3*x - y >= 50;

% Objective: minimize total cost
var int: total_cost = 4*x + 5*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];