% Production planning: minimize cost with linear constraints (all integer quantities)

include "globals.mzn";

% Data (embedded from problem statement)
int: CAP = 1000;        % total capacity
int: DEM = 300;         % demand constraint: 2X + Y >= 300
int: LIM = 600;         % resource constraint: X + 3Z <= 600

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Decision variables (whole-number units)
var 0..CAP: X;
var 0..CAP: Y;
var 0..CAP: Z;

% Constraints
constraint X + Y + Z <= CAP;
constraint 2 * X + Y >= DEM;
constraint X + 3 * Z <= LIM;

% Objective
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(totalCost), "\n"
];