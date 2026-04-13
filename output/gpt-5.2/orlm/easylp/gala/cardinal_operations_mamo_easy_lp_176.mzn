include "globals.mzn";

/* Data (embedded as requested) */
int: minX = 0;   int: maxX = 2000;
int: minY = 0;   int: maxY = 1500;
int: minZ = 0;   int: maxZ = 2500;

int: cX = 10;
int: cY = 15;
int: cZ = 20;

/* Decision variables: whole-number investments */
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

/* Constraints */
constraint X + Y <= 5000;
constraint Y + Z >= 3000;
constraint X + Z <= 4000;

/* Objective: minimize total investment cost */
var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total investment cost = ", show(total_cost), "\n"
];