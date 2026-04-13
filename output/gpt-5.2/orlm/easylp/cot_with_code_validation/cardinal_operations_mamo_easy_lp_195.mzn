% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 80;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

var 0..1000000: totalCost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;