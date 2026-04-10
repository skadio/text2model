% Parameters
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 20;
int: min2Y_plus_Z = 10;
int: maxXZ = 15;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxXZ: Z;

var 0..(costX*maxXY + costY*maxXY + costZ*maxXZ): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint 2*Y + Z >= min2Y_plus_Z;
constraint X + Z <= maxXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;