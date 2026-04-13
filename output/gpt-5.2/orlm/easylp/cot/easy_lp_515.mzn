% Parameters (with values embedded)
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

int: capX = 700;
int: capY = 600;
int: capZ = 400;

% Variables
var 0..capX: X;
var 0..capY: Y;
var 0..capZ: Z;

var int: total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];