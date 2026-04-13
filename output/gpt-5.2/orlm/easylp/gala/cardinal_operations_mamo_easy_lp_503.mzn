include "globals.mzn";

% Data (embedded as required)
int: Bmax = 1000;

int: Xmax = 500;
int: Ymax = 400;
int: Zmax = 600;

int: cX = 100;
int: cY = 200;
int: cZ = 300;

% Decision variables: integer budget allocations
var 0..Xmax: X;
var 0..Ymax: Y;
var 0..Zmax: Z;

% Total budget constraint
constraint X + Y + Z <= Bmax;

% X should not be less than half of Y: X >= Y/2  ->  2X >= Y
constraint 2 * X >= Y;

% | Z - (3/4)X | <= 150
% Avoid fractions by multiplying by 4: |4Z - 3X| <= 600
constraint abs(4 * Z - 3 * X) <= 600;

% Y at least 50 more than Z
constraint Y >= Z + 50;

% Objective: total cost (to achieve "optimal effectiveness" under given per-unit costs)
var int: total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalBudget = ", show(X + Y + Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];