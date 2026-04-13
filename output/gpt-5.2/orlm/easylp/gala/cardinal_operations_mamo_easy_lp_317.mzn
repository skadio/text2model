include "globals.mzn";

/* Data (embedded from problem description) */
int: CAP_TOTAL = 100;
int: MIN_DIFF_XY = 10;
int: CAP_YZ = 70;

int: costX = 5;
int: costY = 3;
int: costZ = 4;

/* Decision variables: whole-number allocations */
var 0..CAP_TOTAL: X;
var 0..CAP_TOTAL: Y;
var 0..CAP_TOTAL: Z;

/* Constraints */
constraint X + Y + Z <= CAP_TOTAL;
constraint X >= Y + MIN_DIFF_XY;
constraint Y + Z <= CAP_YZ;

/* Objective: minimize total cost */
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "MinimumTotalCost = ", show(totalCost), "\n"
];