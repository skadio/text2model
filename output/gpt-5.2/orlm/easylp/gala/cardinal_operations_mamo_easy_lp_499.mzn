include "globals.mzn";

/* Decision variables: number of properties (must be whole numbers) */
var int: X; % residential units
var int: Y; % commercial units

/* Data (embedded as requested) */
int: minTotal = 50;
int: maxCombo = 120;          % 2*X + Y <= 120
int: minBalance = 10;         % X - 3*Y >= 10
int: minX = 20;
int: minY = 10;

int: costX = 5000;
int: costY = 3000;

/* Helpful upper bounds implied by constraints */
constraint X >= minX /\ Y >= minY;
constraint X + Y >= minTotal;
constraint 2*X + Y <= maxCombo;
constraint X - 3*Y >= minBalance;

/* Objective: minimize total investment cost */
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X(residential) = ", show(X), "\n",
  "Y(commercial)  = ", show(Y), "\n",
  "Minimum total investment cost ($) = ", show(totalCost), "\n"
];