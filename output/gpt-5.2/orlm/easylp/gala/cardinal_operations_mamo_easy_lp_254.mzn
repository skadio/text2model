include "globals.mzn";

% Data (embedded from problem statement)
int: BUDGET_MAX = 1000;
int: YZ_MIN = 800;
int: XZ_DIFF_MAX = 200;

int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Decision variables: whole-number allocations
var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;
var 0..BUDGET_MAX: Z;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;
constraint Y + Z >= YZ_MIN;
constraint abs(X - Z) <= XZ_DIFF_MAX;

% Objective: minimize total cost
var 0..(costX*BUDGET_MAX + costY*BUDGET_MAX + costZ*BUDGET_MAX): totalCost;
constraint totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "Minimum total cost ($): ", show(totalCost), "\n",
  "Allocations: X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n"
];