include "globals.mzn";

/*** Data (embedded) ***/
int: BUDGET = 100;     % total resource units available
int: impactX = 3;
int: impactY = 4;
int: minImpact = 300;
int: maxDiff = 20;
int: costX = 5;
int: costY = 2;

/*** Decision variables (integer resource units) ***/
var 0..BUDGET: x;      % units allocated to initiative X
var 0..BUDGET: y;      % units allocated to initiative Y

/*** Constraints ***/
constraint x + y <= BUDGET;
constraint impactX * x + impactY * y >= minImpact;
constraint abs(x - y) <= maxDiff;

/*** Objective ***/
var int: totalCost = costX * x + costY * y;
solve minimize totalCost;

/*** Output ***/
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = ", show(totalCost), "\n"
];