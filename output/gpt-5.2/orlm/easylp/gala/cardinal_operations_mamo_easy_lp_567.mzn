include "globals.mzn";

% Data (embedded from the problem description)
int: BUDGET_MAX = 1000;
int: X_minus_Y_min = 200;
int: ZX_diff_max = 300;
int: YZ_min = 500;

int: impactX = 2;
int: impactY = 3;
int: impactZ = 4;

% Decision variables: whole-number resource allocations
var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;
var 0..BUDGET_MAX: Z;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;
constraint X >= Y + X_minus_Y_min;
constraint abs(Z - X) <= ZX_diff_max;
constraint Y + Z >= YZ_min;

% Objective: minimize total impact points
var 0..(impactX*BUDGET_MAX + impactY*BUDGET_MAX + impactZ*BUDGET_MAX): totalImpact;
constraint totalImpact = impactX*X + impactY*Y + impactZ*Z;

solve minimize totalImpact;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total impact points (rounded) = ", show(totalImpact), "\n"
];