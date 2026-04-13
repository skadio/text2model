% Healthcare resource allocation (integer linear optimization)
% Embed all data directly as requested.

include "globals.mzn";

% Decision variables: whole-number investments (units)
var int: X; % medical staff investment units
var int: Y; % facilities investment units
var int: Z; % technology investment units

% Bounds from minimum allocations and nonnegativity
constraint X >= 200;
constraint Y >= 150;
constraint Z >= 100;

% Total investment budget (units)
constraint X + Y + Z <= 1000;

% Unit costs
int: cX = 10;
int: cY = 15;
int: cZ = 20;

% Objective: minimize total cost
var int: total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;

output [
  "X (medical staff units) = ", show(X), "\n",
  "Y (facilities units)    = ", show(Y), "\n",
  "Z (technology units)    = ", show(Z), "\n",
  "Minimum total cost ($)  = ", show(total_cost), "\n"
];