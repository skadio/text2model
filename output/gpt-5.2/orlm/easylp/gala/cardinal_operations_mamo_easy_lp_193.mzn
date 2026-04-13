% Fleet allocation across routes X, Y, Z
% Minimize cost subject to total fleet limit and minimum route demands.
include "globals.mzn";

% Data (embedded as requested)
int: maxVehicles = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 150;

int: costX = 3;
int: costY = 2;
int: costZ = 5;

% Decision variables (whole numbers)
var minX..maxVehicles: x;  % vehicles on route X
var minY..maxVehicles: y;  % vehicles on route Y
var minZ..maxVehicles: z;  % vehicles on route Z

% Constraints
constraint x + y + z <= maxVehicles;

% Objective: minimize total cost
var 0..(maxVehicles * max([costX, costY, costZ])): totalCost;
constraint totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];