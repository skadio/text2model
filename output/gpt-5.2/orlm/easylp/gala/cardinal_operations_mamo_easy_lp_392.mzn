include "globals.mzn";

/* Data (embedded from problem statement) */
int: costX = 2;
int: costY = 3;
int: costZ = 4;
int: costW = 5;

/* Decision variables: teachers allocated to each school (nonnegative integers) */
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;
var 0..1000: W;

/* Surpluses (nonnegative integers) */
var 0..1000: s1;
var 0..1000: s2;
var 0..1000: s3;
var 0..1000: s4;

/* Constraints */
constraint X + Y - s1 = 50;
constraint Y + Z - s2 = 100;
constraint Z - W + s3 = 20;
constraint X - W + s4 = 30;

/* Objective: minimize total cost */
var int: total_cost = costX*X + costY*Y + costZ*Z + costW*W;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "s1=", show(s1), " s2=", show(s2), " s3=", show(s3), " s4=", show(s4), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];