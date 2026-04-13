% Parameters
int: costX = 5;
int: costY = 3;
int: costZ = 4;

int: maxX = 500;
int: maxY = 300;
int: maxZ = 200;

int: capXY = 1000;
int: capYZ = 800;

int: minDiffXZ = 200;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y <= capXY;
constraint Y + Z <= capYZ;

% "Difference ... should be at least 200 units" interpreted as absolute difference
constraint abs(X - Z) >= minDiffXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;