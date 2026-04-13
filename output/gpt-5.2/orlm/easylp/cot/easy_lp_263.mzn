% Parameters (with values embedded)
int: costX = 5000;
int: costY = 7000;
int: costZ = 10000;

int: maxTotalHires = 50;

int: minX = 10;
int: minY = 15;
int: minZ = 20;

% Variables
var 0..maxTotalHires: X;
var 0..maxTotalHires: Y;
var 0..maxTotalHires: Z;

var int: totalCost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= maxTotalHires;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;