% Parameters
int: minXY = 1000;
int: maxDiffYZ = 500;
int: sumXZ = 1500;

int: costX = 8;
int: costY = 5;
int: costZ = 2;

% Variables
var 0..sumXZ: X;
var 0..(sumXZ + maxDiffYZ): Y;
var 0..sumXZ: Z;

var 0..(costX*sumXZ + costY*(sumXZ + maxDiffYZ) + costZ*sumXZ): totalCost;

% Constraints
constraint X + Y >= minXY;
constraint abs(Y - Z) <= maxDiffYZ;
constraint X + Z = sumXZ;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;