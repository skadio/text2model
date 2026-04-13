include "globals.mzn";

/* Data (embedded as required) */
int: max_total_hires = 100;

int: minX = 20;
int: minY = 30;
int: minZ = 10;

int: salX = 50000;
int: salY = 70000;
int: salZ = 90000;

/* Decision variables: number of hires in each category (whole numbers) */
var minX..max_total_hires: X;
var minY..max_total_hires: Y;
var minZ..max_total_hires: Z;

/* Constraints */
constraint X + Y + Z <= max_total_hires;

/* Objective: minimize total salary cost */
var int: total_cost = salX*X + salY*Y + salZ*Z;

solve minimize total_cost;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];