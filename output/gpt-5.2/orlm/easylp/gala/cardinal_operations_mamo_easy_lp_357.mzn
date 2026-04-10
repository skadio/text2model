include "globals.mzn";

/* Data (embedded from problem statement) */
float: c1 = 1.5;
float: c2 = 2.0;
float: c3 = 3.0;
float: c4 = 4.0;

int: x1_max = 250;
int: x2_max = 250;
int: x3_max = 150;
int: x4_max = 150;

/* Decision variables: integer number of units */
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;
var 0..x4_max: x4;

/* Constraints */
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 300;
constraint x1 + x3 >= 200;
constraint x2 + x4 >= 100;

/* Objective: minimize total cost (use cents to keep integer objective) */
var int: cost_cents = 150*x1 + 200*x2 + 300*x3 + 400*x4;

solve minimize cost_cents;

/* Output: minimum cost rounded to nearest dollar */
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "MinCost($)=", show( round( (int2float(cost_cents)) / 100.0 ) ), "\n"
];