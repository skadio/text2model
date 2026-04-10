% Parameters
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: minX = 0;   int: maxX = 2000;
int: minY = 0;   int: maxY = 1500;
int: minZ = 0;   int: maxZ = 2500;

int: maxXY = 5000;
int: minYZ = 3000;
int: maxXZ = 4000;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z >= minYZ;
constraint X + Z <= maxXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;