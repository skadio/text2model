% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 80;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxYZ: Z;

var 0..(costX*maxXY + costY*maxXY + costZ*maxYZ): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;