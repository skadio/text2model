% Parameters
int: B = 500;
int: reqXY = 400;
int: maxDiffYZ = 150;
int: minDiffXZ = 100;

int: cX = 50;
int: cY = 30;
int: cZ = 80;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint 2*X + 3*Y >= reqXY;

constraint Y - Z <= maxDiffYZ;

constraint X - Z >= minDiffXZ;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;