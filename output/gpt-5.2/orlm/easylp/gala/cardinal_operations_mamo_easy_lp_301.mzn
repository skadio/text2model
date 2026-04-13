include "globals.mzn";

/* Data (embedded from description) */
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: XY_max = 20;
int: XZ_max = 15;
int: min_2Y_plus_Z = 10;

/* Decision variables: whole-number investments */
var 0..XY_max: x;
var 0..XY_max: y;
var 0..XZ_max: z;

/* Constraints */
constraint x + y <= XY_max;
constraint 2*y + z >= min_2Y_plus_Z;
constraint x + z <= XZ_max;

/* Objective: minimize total cost */
var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

/* Output */
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];