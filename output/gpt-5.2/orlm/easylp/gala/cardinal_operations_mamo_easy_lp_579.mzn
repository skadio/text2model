include "globals.mzn";

% Data (embedded as requested)
int: cap = 50;

int: minX = 10;  % Residential
int: minY = 15;  % Commercial
int: minZ = 5;   % Industrial

int: costX = 10000;
int: costY = 8000;
int: costZ = 6000;

% Decision variables: number of projects (must be whole numbers)
var minX..cap: X;
var minY..cap: Y;
var minZ..cap: Z;

% Constraints
constraint X + Y + Z <= cap;
constraint 2*X - Y + Z >= 20;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X (Residential) = ", show(X), "\n",
  "Y (Commercial)  = ", show(Y), "\n",
  "Z (Industrial)  = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];