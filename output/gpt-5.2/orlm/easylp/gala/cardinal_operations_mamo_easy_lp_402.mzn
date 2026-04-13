include "globals.mzn";

/*
  Decision variables: integer allocations to units X1..X4.
  Bounds are not explicitly given in the statement; we choose safe upper bounds
  implied by constraints (and keep non-negativity).
*/
var 0..1000: X1;
var 0..1000: X2;
var 0..1000: X3;
var 0..1000: X4;

/* Constraints */
constraint X1 + X2 <= 1000;
constraint 2*X1 + X3 >= 800;
constraint X2 + 3*X4 <= 600;

/* "X1 - half of X4 >= 200"  -> 2*X1 - X4 >= 400 to keep integrality */
constraint 2*X1 - X4 >= 400;

/* Objective: minimize total cost */
var int: total_cost = 2*X1 + 3*X2 + 4*X3 + 5*X4;

solve minimize total_cost;

/* Output */
output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "X4 = ", show(X4), "\n",
  "Minimum total cost (rounded to nearest whole number) = ", show(total_cost), "\n"
];