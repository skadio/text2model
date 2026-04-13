include "globals.mzn";

/* Data (all embedded, as requested) */
int: cap1 = 50;          % 2X + 3Y <= 50
int: req2 = 10;          % 5X + 1Y >= 10
int: diffMax = 5;        % |X - Y| <= 5

int: costX = 10;         % in thousands of dollars
int: costY = 20;         % in thousands of dollars

/* Decision variables: allocations must be whole numbers */
var 0..cap1: X;
var 0..cap1: Y;

/* Constraints */
constraint 2*X + 3*Y <= cap1;
constraint 5*X + Y >= req2;
constraint abs(X - Y) <= diffMax;

/* Objective: minimize total cost (in thousands) */
var 0..1000000: totalCost = costX*X + costY*Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (thousands) = ", show(totalCost), "\n"
];