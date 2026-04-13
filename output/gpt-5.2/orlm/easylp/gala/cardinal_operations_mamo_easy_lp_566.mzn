% Environmental agency resource allocation (integer linear optimization)

include "globals.mzn";

% Data (embedded as required)
int: maxX = 1500;
int: maxY = 1300;
int: maxZ = 1200;

int: cX = 50;
int: cY = 60;
int: cZ = 70;

% Decision variables: allocations (whole numbers)
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint X + Y <= 2000;
constraint X + Z >= 1000;
constraint Y - Z = 500;
constraint X - Y >= -700;

% Objective: minimize total cost
var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];