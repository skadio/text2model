include "globals.mzn";

/* Data (embedded from problem statement) */
int: maxX = 30;
int: maxY = 20;

int: a1 = 5;    int: b1 = 3;    int: rhs1 = 200;  % 5*X + 3*Y <= 200
int: a2 = 10;   int: b2 = 15;   int: rhs2 = 300;  % 10*X + 15*Y >= 300

int: diffLimit = 50;

int: costX = 10000;
int: costY = 15000;

/* Decision variables */
var 0..maxX: X;
var 0..maxY: Y;

/* Constraints */
constraint a1 * X + b1 * Y <= rhs1;
constraint a2 * X + b2 * Y >= rhs2;
constraint abs(X - Y) <= diffLimit;

/* Objective */
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

/* Output */
output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(totalCost), "\n"
];