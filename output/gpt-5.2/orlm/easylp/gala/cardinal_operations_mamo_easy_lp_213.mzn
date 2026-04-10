% Resource allocation among programs X, Y, Z with minimum requirements and budget cap.
% Data is embedded as requested.

include "globals.mzn";

% Parameters
int: total_cap = 100;

int: minX = 10;
int: minY = 20;
int: minZ = 15;

int: costX = 30;
int: costY = 20;
int: costZ = 50;

% Decision variables (integer allocations)
var minX..total_cap: x;
var minY..total_cap: y;
var minZ..total_cap: z;

% Constraints
constraint x + y + z <= total_cap;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];