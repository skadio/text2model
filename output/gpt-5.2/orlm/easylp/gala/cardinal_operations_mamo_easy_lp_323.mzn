include "globals.mzn";

/* Data (embedded from the description) */
int: maxTotal = 50;
int: costX = 10000;  % residential
int: costY = 15000;  % commercial
int: costZ = 20000;  % industrial

int: maxX = 20;
int: maxY = 15;
int: maxZ = 25;

/* Decision variables: number of properties of each type (whole numbers) */
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

/* Constraints */
constraint X + Y + Z <= maxTotal;
constraint X >= 2 * Y;
constraint X + Y >= 30;
constraint Y + Z <= 40;

/* Objective: minimize total investment cost */
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X (residential) = ", show(X), "\n",
  "Y (commercial)  = ", show(Y), "\n",
  "Z (industrial)  = ", show(Z), "\n",
  "Total cost      = $", show(totalCost), "\n"
];