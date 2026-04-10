% Parameters
int: costX = 5000;
int: costY = 7000;
int: costZ = 10000;

int: maxTotalHires = 50;

int: minX = 10;
int: minY = 15;
int: minZ = 20;

% Variables
var minX..maxTotalHires: X;
var minY..maxTotalHires: Y;
var minZ..maxTotalHires: Z;

var 0..(costX*maxTotalHires + costY*maxTotalHires + costZ*maxTotalHires): totalCost;

% Constraints
constraint X + Y + Z <= maxTotalHires;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;