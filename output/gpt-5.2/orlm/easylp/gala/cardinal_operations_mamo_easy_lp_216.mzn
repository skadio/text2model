include "globals.mzn";

/* Data (embedded as requested) */
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

/* Decision variables: whole-number allocations */
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxYZ: Z;

/* Constraints */
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

/* Objective: minimize total cost */
var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];