include "globals.mzn";

/* Data (embedded from the problem statement) */
int: costX = 1000;
int: costY = 2000;

int: a1 = 5;     int: b1 = 10;    int: rhs1 = 50000;   % 5X + 10Y >= 50000
int: a2 = 3;     int: b2 = 4;     int: rhs2 = 30000;   % 3X + 4Y <= 30000
int: diffMin = 1000;                                % X - Y >= 1000

/* Decision variables (whole numbers within bounds)
   Upper bounds are chosen conservatively from constraints:
   - From 5X + 10Y >= 50000: X + 2Y >= 10000 -> X <= 10000 when Y=0
   - From 3X + 4Y <= 30000: X <= 10000 when Y=0
   Also Y must satisfy 4Y <= 30000 -> Y <= 7500
*/
var 0..10000: X;
var 0..7500:  Y;

/* Constraints */
constraint a1 * X + b1 * Y >= rhs1;
constraint a2 * X + b2 * Y <= rhs2;
constraint X - Y >= diffMin;

/* Objective: minimize support points */
var int: supportPoints = costX * X + costY * Y;
solve minimize supportPoints;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "SupportPoints = ", show(supportPoints), "\n"
];