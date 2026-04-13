% Parameters (with values embedded)
int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: maxXY = 1000;
int: min2XZ = 500;
int: diffYZ = 200;
int: maxXZ = 800;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxXZ: Z;

var int: totalCost;

% Constraints
constraint X + Y <= maxXY;
constraint 2 * X + Z >= min2XZ;
constraint abs(Y - Z) = diffYZ;
constraint X + Z <= maxXZ;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;