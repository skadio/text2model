include "globals.mzn";

/* Data (embedded as requested) */
int: c1 = 20;
int: c2 = 30;
int: c3 = 40;
int: c4 = 50;

/* Bounds: "within specific bounds" not explicitly given, so we use safe, practical nonnegative
   bounds implied by the constraints to keep the model finite. */
int: UB = 1000;

/* Decision variables: integer allocations */
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

/* Constraints */
constraint x1 + x2 <= 200;
constraint 2*x1 + 3*x3 >= 150;

/* "difference between half of x4 and x1 should not exceed 75"
   -> absolute difference constraint */
constraint abs(2*x1 - x4) <= 150;  % abs(x1 - x4/2) <= 75, multiplied by 2

/* x3 + x4/2 - x2 >= 100  ->  2*x3 + x4 - 2*x2 >= 200 */
constraint 2*x3 + x4 - 2*x2 >= 200;

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