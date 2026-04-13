% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxXY = 20;
int: minYZ = 30;
int: maxDiffXZ = 10;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..(minYZ + maxDiffXZ + maxXY): Z;

var 0..(costX*maxXY + costY*maxXY + costZ*(minYZ + maxDiffXZ + maxXY)): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z >= minYZ;
constraint abs(X - Z) <= maxDiffXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;