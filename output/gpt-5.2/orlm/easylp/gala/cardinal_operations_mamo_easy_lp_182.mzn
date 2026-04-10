% Resource allocation among projects X, Y, Z (all integer units)
include "globals.mzn";

% Data (embedded as required)
int: BUDGET = 100;
int: cX = 10;
int: cY = 20;
int: cZ = 30;

% Decision variables: integer allocations
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= 2 * Y;
constraint Z >= X + 10;

% Objective: minimize total cost
var int: totalCost = cX * X + cY * Y + cZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = $", show(totalCost), "\n"
];