% Parameters (with values embedded)
int: costX = 5;
int: costY = 6;
int: costZ = 3;

int: minX = 0; int: maxX = 700;
int: minY = 0; int: maxY = 500;
int: minZ = 0; int: maxZ = 600;

int: capXY = 1000;
int: capYZ = 1200;
int: minDiffXZ = 200;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var int: total_cost = costX * X + costY * Y + costZ * Z;

% Constraints
constraint X + Y <= capXY;
constraint Y + Z <= capYZ;
constraint X - Z >= minDiffXZ;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total transportation cost = ", show(total_cost), "\n"
];