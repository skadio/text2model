include "globals.mzn";

/* Data (embedded as required) */
int: BUDGET_MAX = 1000;

int: minX = 200;
int: minY = 100;
int: minZ = 50;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

/* Decision variables: whole-number allocations */
var minX..BUDGET_MAX: x;
var minY..BUDGET_MAX: y;
var minZ..BUDGET_MAX: z;

/* Budget constraint */
constraint x + y + z <= BUDGET_MAX;

/* Objective: minimize total cost */
var 0..(costX*BUDGET_MAX + costY*BUDGET_MAX + costZ*BUDGET_MAX): total_cost;
constraint total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

/* Output */
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];