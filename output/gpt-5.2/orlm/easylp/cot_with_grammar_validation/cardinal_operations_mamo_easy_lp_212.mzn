% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: minXY = 50;
int: maxXZ = 100;
int: minDiffYZ = 10;

% Variables
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

var 0..(costX*100 + costY*100 + costZ*100): total_cost;

% Constraints
constraint X + Y >= minXY;
constraint X + Z <= maxXZ;
constraint Y - Z >= minDiffYZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;