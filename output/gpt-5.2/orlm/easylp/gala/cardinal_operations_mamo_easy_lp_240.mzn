% Resource allocation for tasks X, Y, Z (integer units), minimizing total cost.

include "globals.mzn";

% Parameters (embedded from the problem statement)
int: maxTotalUnits = 20;
int: minFeasibility = 5;          % 2*X + Y >= 5
int: maxDiffYZ = 10;              % |Y - Z| <= 10

int: costX = 100;
int: costY = 200;
int: costZ = 150;

% Decision variables: whole resource units
var 0..maxTotalUnits: X;
var 0..maxTotalUnits: Y;
var 0..maxTotalUnits: Z;

% Constraints
constraint X + Y + Z <= maxTotalUnits;
constraint 2*X + Y >= minFeasibility;
constraint abs(Y - Z) <= maxDiffYZ;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];