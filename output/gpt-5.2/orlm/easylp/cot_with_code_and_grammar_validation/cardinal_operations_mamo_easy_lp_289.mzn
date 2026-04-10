% Parameters
int: cX = 5;
int: cY = 4;
int: cZ = 3;

int: maxXY = 100;
int: minXZ = 50;
int: maxDiffYZ = 20;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxXY: Z;

var int: total_effort;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;

constraint Y - Z <= maxDiffYZ;
constraint Z - Y <= maxDiffYZ;

constraint total_effort = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_effort;