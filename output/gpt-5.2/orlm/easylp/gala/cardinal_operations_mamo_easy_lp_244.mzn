include "globals.mzn";

% Data (embedded as required)
int: budget = 100;
int: min_standard = 50;
int: max_diff_xz = 20;

int: costX = 5000;
int: costY = 4000;
int: costZ = 3000;

% Decision variables: integer resource units allocated to projects X, Y, Z
var 0..budget: x;
var 0..budget: y;
var 0..budget: z;

% Constraints
constraint x + y + z <= budget;
constraint 2*x + 3*y >= min_standard;
constraint abs(x - z) <= max_diff_xz;

% Objective: minimize total cost
var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];