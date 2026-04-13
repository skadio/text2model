include "globals.mzn";

/* Data (embedded from problem statement) */
int: c1 = 4;
int: c2 = 5;
int: c3 = 6;

int: ub1 = 1500;
int: ub2 = 1200;
int: ub3 = 800;

/* Decision variables: number of trucks on each route */
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;

/* Constraints */
constraint x1 + x2 <= 2000;
constraint x2 + x3 >= 1000;
constraint x1 - 2 * x3 = 500;

/* Objective: minimize total operating cost */
var int: total_cost = c1 * x1 + c2 * x2 + c3 * x3;

solve minimize total_cost;

/* Output */
output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];