include "globals.mzn";

/* Data (embedded from problem statement) */
int: c1 = 10;
int: c2 = 20;
int: c3 = 30;
int: c4 = 40;

int: ub1 = 100;
int: ub2 = 100;
int: ub3 = 100;
int: ub4 = 100;

/* Decision variables: integer (indivisible) allocations */
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

/* Constraints */
constraint x1 + x2 <= 100;
constraint x3 + x4 >= 50;
constraint 2*x1 + 3*x2 - x3 <= 0;
constraint 4*x3 - 2*x2 = 5*x4;

/* Objective: minimize total cost */
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

/* Output */
output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];