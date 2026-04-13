include "globals.mzn";

/* Data (embedded from problem statement) */
int: x1_min = 0;  int: x1_max = 24;
int: x2_min = 0;  int: x2_max = 12;
int: x3_min = 0;  int: x3_max = 30;

int: c1 = 5;
int: c2 = 6;
int: c3 = 3;

/* Decision variables: whole-number working hours */
var x1_min..x1_max: X1;
var x2_min..x2_max: X2;
var x3_min..x3_max: X3;

/* Operational constraints */
constraint 2*X1 + 3*X2 + 1*X3 >= 10;
constraint 4*X1 + 5*X2 + 2*X3 <= 20;
constraint 1*X1 - 2*X2 + 1*X3 >= 8;

/* Objective: minimize total cost */
var int: total_cost = c1*X1 + c2*X2 + c3*X3;

solve minimize total_cost;

/* Output */
output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "min_total_cost=", show(total_cost), "\n"
];