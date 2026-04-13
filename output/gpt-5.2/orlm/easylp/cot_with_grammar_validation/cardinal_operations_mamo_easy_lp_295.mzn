% Parameters
int: costX = 4;
int: costY = 3;
int: costZ = 2;

int: maxXY = 25;
int: minXZ = 15;
int: maxYZ = 20;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxYZ: Z;

var 0..(costX*maxXY + costY*maxXY + costZ*maxYZ): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint Y + Z <= maxYZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;