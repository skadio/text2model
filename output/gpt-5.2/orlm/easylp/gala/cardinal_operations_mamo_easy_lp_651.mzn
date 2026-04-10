include "globals.mzn";

/*
  Investment units in four property types:
    x1 = residential
    x2 = commercial
    x3 = industrial
    x4 = recreational

  Minimize total cost subject to linear constraints.
  All data embedded as requested.
*/

/* Decision variables (nonnegative integers) */
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

/* Constraints */
constraint x1 + x2 <= 50;
constraint x3 + x4 <= 70;

/* ROI constraint:
   0.5*x1 - 0.25*x2 + 0.15*x3 + 1*x4 >= 20
   Multiply by 20 to keep integers:
   10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400
*/
constraint 10*x1 - 5*x2 + 3*x3 + 20*x4 >= 400;

/* Diversification/risk constraint:
   2.5*x2 + 0.75*x3 - x1 - x4 <= 30
   Multiply by 4:
   10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120
*/
constraint 10*x2 + 3*x3 - 4*x1 - 4*x4 <= 120;

/* Objective: minimize total investment cost */
var int: total_cost = 500*x1 + 300*x2 + 200*x3 + 100*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];