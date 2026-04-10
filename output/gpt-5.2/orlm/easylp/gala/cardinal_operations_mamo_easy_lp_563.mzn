% Budget allocation optimization (all data embedded)

include "globals.mzn";

% Data
int: TOTAL_BUDGET = 1000;
int: MIN_DIFF_XY = 200;
int: MAX_Z = 300;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Decision variables (whole-number allocations)
var 0..TOTAL_BUDGET: X;
var 0..TOTAL_BUDGET: Y;
var 0..MAX_Z: Z;

% Constraints
constraint X + Y + Z = TOTAL_BUDGET;
constraint X >= Y + MIN_DIFF_XY;

% Objective: minimize total cost
var 0..(costX*TOTAL_BUDGET + costY*TOTAL_BUDGET + costZ*TOTAL_BUDGET): totalCost;
constraint totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(totalCost), "\n"
];