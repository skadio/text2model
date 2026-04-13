include "globals.mzn";

/* Data (embedded from the description) */
int: costX = 50000;
int: costY = 80000;

int: maxTotal = 10;
int: maxX = 7;
int: maxY = 6;

/* Decision variables: number of units (integers) */
var 0..maxX: x;  % units of property X
var 0..maxY: y;  % units of property Y

/* Constraints */
constraint x + y <= maxTotal;

/* "X must be at least half of Y plus 3": x >= y/2 + 3.
   To keep integers without fractions: 2x >= y + 6. */
constraint 2 * x >= y + 6;

/* Objective: minimize total cost */
var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];