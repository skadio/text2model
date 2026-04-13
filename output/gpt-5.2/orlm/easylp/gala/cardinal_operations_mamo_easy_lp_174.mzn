% Marketing budget allocation (integer linear optimization)
include "globals.mzn";

% Decision variables: budgets (whole numbers)
var 0..5000: X;
var 0..5000: Y;
var 0..5000: Z;

% Parameters (embedded from description)
int: BMAX = 5000;

% Cost per unit (dollars per budget unit)
int: cX = 100;
int: cY = 50;
int: cZ = 20;

% Constraints
constraint X + Y + Z <= BMAX;

% Reach objective: 5X - 3Y + Z >= 2000
constraint 5*X - 3*Y + Z >= 2000;

% Spending relationship: (X+Z) cannot exceed (2Y + 1000)
% i.e., X + Z - 2Y <= 1000
constraint X + Z - 2*Y <= 1000;

% Objective: minimize total cost
var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];