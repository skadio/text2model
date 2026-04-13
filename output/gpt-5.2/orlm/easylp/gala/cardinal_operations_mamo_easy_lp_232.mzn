% Resource allocation for areas X, Y, Z (integer decisions)
include "globals.mzn";

% Data (embedded as requested)
int: BUDGET_MAX = 1000;

int: aX = 4;
int: aY = 5;
int: TARGET_MIN = 3000;

int: bZ = 1;
int: bY = 3;
int: INTERDEP_MIN = -500;   % constraint: Z - 3Y >= -500

int: cX = 2;
int: cY = 3;
int: cZ = 1;

% Decision variables (nonnegative whole units)
var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;
var 0..BUDGET_MAX: Z;

% Constraints
constraint X + Y + Z <= BUDGET_MAX;
constraint aX * X + aY * Y >= TARGET_MIN;
constraint Z - bY * Y >= INTERDEP_MIN;

% Objective: minimize total cost
var int: total_cost = cX * X + cY * Y + cZ * Z;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];