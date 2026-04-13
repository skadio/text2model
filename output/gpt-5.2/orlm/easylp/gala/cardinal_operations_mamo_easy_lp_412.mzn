include "globals.mzn";

/* Data (embedded from description) */
int: c1 = 200;
int: c2 = 300;
int: c3 = 400;
int: c4 = 500;

/* Bounds on allocations (not provided explicitly in the description).
   Use broad nonnegative integer bounds implied by the constraint limits. */
var 0..1000: x1;
var 0..1000: x2;
var 0..600:  x3;   % because 2*x3 + x4 <= 1200
var 0..1200: x4;

/* Constraints */
constraint x1 + x2 <= 1000;
constraint 2*x3 + x4 <= 1200;
constraint x1 + x2 + x3 + x4 >= 500;

/* Objective */
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];