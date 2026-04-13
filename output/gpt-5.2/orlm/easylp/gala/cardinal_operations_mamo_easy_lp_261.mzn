include "globals.mzn";

/* Data (embedded, per instructions) */
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

int: total_hires = 50;

int: expX = 5;
int: expY = 3;
int: expZ = 7;
int: min_total_exp = 200;

int: minX = 10;
int: maxY = 20;

/* Decision variables: number of hires in each department */
var 0..total_hires: x;
var 0..total_hires: y;
var 0..total_hires: z;

/* Constraints */
constraint x + y + z = total_hires;
constraint expX*x + expY*y + expZ*z >= min_total_exp;
constraint x >= minX;
constraint y <= maxY;

/* Objective: minimize total cost */
var int: total_cost = costX*x + costY*y + costZ*z;
solve minimize total_cost;

/* Output */
output [
  "x (Dept X hires) = ", show(x), "\n",
  "y (Dept Y hires) = ", show(y), "\n",
  "z (Dept Z hires) = ", show(z), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];