% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxXY = 100;
int: minXZ = 50;
int: maxDiffYZ = 20;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxXY: Z;
var 0..(costX*maxXY + costY*maxXY + costZ*maxXY): total_effort;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint abs(Y - Z) <= maxDiffYZ;

constraint total_effort = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_effort;