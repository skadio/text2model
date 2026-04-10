% Parameters
int: max_XY = 1000;
int: min_YZ = 500;
int: max_abs_XZ = 200;

int: costX = 4;
int: costY = 3;
int: costZ = 2;

int: maxAlloc = 1200;

% Variables
var 0..maxAlloc: X;
var 0..maxAlloc: Y;
var 0..maxAlloc: Z;

var 0..(costX*maxAlloc + costY*maxAlloc + costZ*maxAlloc): totalCost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z >= min_YZ;

constraint X - Z <= max_abs_XZ;
constraint Z - X <= max_abs_XZ;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;