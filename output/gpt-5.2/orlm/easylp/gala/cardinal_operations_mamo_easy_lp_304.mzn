include "globals.mzn";

/* Problem data (embedded as requested) */
int: BUDGET = 1000;
int: x_min_excess_over_2y = 200;
int: z_min_over_y = 100;

int: costX = 2;
int: costY = 3;
int: costZ = 1;

/* Decision variables: whole-number fund allocations */
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

/* Constraints */
constraint X + Y + Z <= BUDGET;
constraint X >= 2 * Y + x_min_excess_over_2y;
constraint Z >= Y + z_min_over_y;

/* Objective: minimize total cost */
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];