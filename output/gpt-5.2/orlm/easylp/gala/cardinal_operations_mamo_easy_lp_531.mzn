% Telecommunications resource allocation (integer linear optimization)

include "globals.mzn";

% Data (embedded as requested)
int: cX = 2;
int: cY = 3;
int: cZ = 1;

% Decision variables: integer allocations
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Constraints
constraint X + Y <= 1000;
constraint 2*X + Z >= 500;
constraint abs(Y - Z) = 200;
constraint X + Z <= 800;

% Objective: minimize total cost
var int: totalCost = cX*X + cY*Y + cZ*Z;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];