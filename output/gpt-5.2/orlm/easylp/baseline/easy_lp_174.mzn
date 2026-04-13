% Budget allocation for three marketing campaigns X, Y, Z
% Minimize total cost subject to budget and reach/relative-spend constraints.

include "globals.mzn";

% Decision variables: whole-number budgets
var 0..5000: X;
var 0..5000: Y;
var 0..5000: Z;

% Total budget cannot exceed 5000
constraint X + Y + Z <= 5000;

% Reach objective: 5X - 3Y + Z >= 2000
constraint 5*X - 3*Y + Z >= 2000;

% Combined spending on X and Z cannot exceed twice Y by more than 1000:
% (X + Z) - 2Y <= 1000  <=>  X + Z <= 2Y + 1000
constraint X + Z <= 2*Y + 1000;

% Costs per unit (dollars)
int: costX = 100;
int: costY = 50;
int: costZ = 20;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];