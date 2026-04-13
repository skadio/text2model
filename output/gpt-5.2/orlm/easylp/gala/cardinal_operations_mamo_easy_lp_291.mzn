% Resource allocation across departments X, Y, Z
% Minimize total cost subject to budget and minimum allocations.
include "globals.mzn";

% Data (embedded as required)
int: total_budget = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 120;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Decision variables (whole-number allocations)
var minX..total_budget: x;
var minY..total_budget: y;
var minZ..total_budget: z;

% Constraints
constraint x + y + z <= total_budget;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];