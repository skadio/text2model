include "globals.mzn";

% Data (embedded from the problem statement)
int: total_cap = 1000;
int: yz_cap = 800;
int: x_extra = 200;

int: costX = 500;
int: costY = 700;
int: costZ = 300;

% Decision variables: whole-number allocations
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

% Constraints
constraint X + Y + Z <= total_cap;
constraint X >= 2 * Y + x_extra;
constraint Y + Z <= yz_cap;

% Objective: minimize total cost
var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): totalCost =
  costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "Minimum total cost = $", show(totalCost), "\n",
  "Allocations: X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n"
];