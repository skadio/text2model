include "globals.mzn";

/* Data embedded from the problem statement */
int: max_total = 5000;
int: min_xy = 2000;
int: max_yz = 2500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

/* Decision variables: whole-number allocations */
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

/* Constraints */
constraint X + Y + Z <= max_total;
constraint X + Y >= min_xy;
constraint 2 * X = Y;          % "twice the allocation for location X than Y" interpreted as Y = 2X
constraint Y + Z <= max_yz;

/* Objective: minimize total cost */
var 0..(costX*max_total + costY*max_total + costZ*max_total): total_cost;
constraint total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

/* Output (already an integer, so "rounded" is the same) */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];