include "globals.mzn";

/* Embedded data (no .dzn expected) */
int: BUDGET_MAX = 1000;

int: cX = 50;
int: cY = 30;
int: cZ = 20;

/* Decision variables: whole-dollar allocations */
var 0..BUDGET_MAX: X;   % General Medicine
var 0..BUDGET_MAX: Y;   % Pediatrics
var 0..BUDGET_MAX: Z;   % Surgery

/* Constraints */
constraint X + Y + Z <= BUDGET_MAX;
constraint X >= 2 * Y + 200;
constraint Z >= Y + 150;

/* Objective: minimize total cost */
var 0..(cX*BUDGET_MAX + cY*BUDGET_MAX + cZ*BUDGET_MAX): totalCost =
  cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(totalCost), "\n"
];