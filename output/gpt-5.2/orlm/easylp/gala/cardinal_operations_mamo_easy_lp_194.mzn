% Vehicle allocation cost minimization (all data embedded)

include "globals.mzn";

% Costs ($ per vehicle)
int: cX = 5;
int: cY = 4;
int: cZ = 3;

% Limits/requirements
int: maxTotal = 1000;
int: min2XplusY = 200;
int: maxXplusZ = 300;

% Decision variables: numbers of vehicles (whole numbers)
var 0..maxTotal: X;
var 0..maxTotal: Y;
var 0..maxTotal: Z;

% Constraints
constraint X + Y + Z <= maxTotal;
constraint 2*X + Y >= min2XplusY;
constraint X + Z <= maxXplusZ;

% Objective: minimize total cost
var 0..(cX*maxTotal + cY*maxTotal + cZ*maxTotal): totalCost;
constraint totalCost = cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];