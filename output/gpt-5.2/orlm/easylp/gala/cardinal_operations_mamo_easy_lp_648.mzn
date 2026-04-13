include "globals.mzn";

/*
  Military logistics resource allocation (integer variables)
  Minimize total cost subject to linear constraints.

  Data embedded as required.
*/

/* Costs */
int: c1 = 5000;
int: c2 = 3000;
int: c3 = 4000;
int: c4 = 2000;

/* Bounds */
var 0..3000: x1;
var 0..2500: x2;
var 0..1500: x3;
var 0..300:  x4;

/* Total allocation cap */
constraint x1 + x2 + x3 + x4 <= 10000;

/*
  To avoid floating point, scale all constraints by 10 (LCM for 0.5, 0.7, 0.2).
  3.5 -> 35/10, 4.7 -> 47/10, 2.5 -> 25/10.
*/

/* 5*x1 >= 2000 + 3.5*x2  => 50*x1 >= 20000 + 35*x2 */
constraint 50*x1 >= 20000 + 35*x2;

/* 4.7*x4 <= x3 + 3500 => 47*x4 <= 10*x3 + 35000 */
constraint 47*x4 <= 10*x3 + 35000;

/* x2 + 3.5*x3 + x4 - 2.5*x1 >= 1000 => 10*x2 + 35*x3 + 10*x4 - 25*x1 >= 10000 */
constraint 10*x2 + 35*x3 + 10*x4 - 25*x1 >= 10000;

/* Objective */
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];