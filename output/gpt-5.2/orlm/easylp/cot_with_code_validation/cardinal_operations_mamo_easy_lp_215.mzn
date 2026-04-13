% Parameters
int: costX = 5;
int: costY = 3;
int: costZ = 4;

int: maxXY = 1000;
int: maxYZ = 800;
int: minDiffXZ = 200;

int: maxX = 500;
int: maxY = 300;
int: maxZ = 200;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;

constraint abs(X - Z) >= minDiffXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;