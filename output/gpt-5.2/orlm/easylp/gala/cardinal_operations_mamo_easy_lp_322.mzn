include "globals.mzn";

/* Data (embedded as required) */
int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxXY = 20;          % X + Y <= 20
int: minYZ = 30;          % Y + Z >= 30
int: maxDiffXZ = 10;      % |X - Z| <= 10

/* Decision variables: number of packages to each region (whole numbers) */
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

/* Constraints */
constraint X + Y <= maxXY;
constraint Y + Z >= minYZ;
constraint abs(X - Z) <= maxDiffXZ;

/* Objective: minimize total cost */
var int: totalCost = costX * X + costY * Y + costZ * Z;
solve minimize totalCost;

/* Output: objective is already integer dollars, so "rounded up" is the same value */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded up) = $", show(totalCost), "\n"
];