% Parameters (with values embedded)
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

% Variables
var 0..1000: X;   % from X+Y <= 1000 and Y >= 0
var 0..1000: Y;   % safe upper bound; additionally constrained by Y+Z <= 800
var 0..800:  Z;   % from Y+Z <= 800 and Y >= 0

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

% Objective
var int: TotalCost = costX * X + costY * Y + costZ * Z;
solve minimize TotalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(TotalCost), "\n"
];