include "globals.mzn";

/* Data embedded from the problem statement */
int: LAND_MAX = 1000;          % x1 + x2 <= 1000
int: DIVERSITY_MIN = 500;      % 2*x3 + 3*x4 >= 500
int: DIFF_MAX = 200;           % |x1 - x4| <= 200

int: c1 = 50;
int: c2 = 30;
int: c3 = 20;
int: c4 = 10;

/* Decision variables: whole-number allocations (nonnegative) */
var 0..LAND_MAX: x1;
var 0..LAND_MAX: x2;
var 0..LAND_MAX: x3;
var 0..LAND_MAX: x4;

/* Constraints */
constraint x1 + x2 <= LAND_MAX;
constraint 2*x3 + 3*x4 >= DIVERSITY_MIN;
constraint abs(x1 - x4) <= DIFF_MAX;

/* (1/2)*x3 >= x2  ->  x3 >= 2*x2 to keep integrality exact */
constraint x3 >= 2*x2;

/* Objective */
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

/* Output */
output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];