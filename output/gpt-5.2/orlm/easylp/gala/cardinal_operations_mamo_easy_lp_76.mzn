% Construction project allocation: minimize total cost
% Data embedded as required.

int: maxTotal = 50;
int: minDiversity = 30;          % 2*X + Y >= 30
int: maxDiff = 10;               % |X - Y| <= 10
int: maxX = 40;
int: maxY = 20;

int: costX = 2000;
int: costY = 3000;

/* Decision variables */
var 0..maxX: X;                  % number of type X projects
var 0..maxY: Y;                  % number of type Y projects

/* Constraints */
constraint X + Y <= maxTotal;
constraint 2 * X + Y >= minDiversity;
constraint abs(X - Y) <= maxDiff;

/* Objective */
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];