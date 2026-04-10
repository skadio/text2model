% Parameters
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxYZ: Z;

var 0..(costX*maxXY + costY*maxXY + costZ*maxYZ): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;