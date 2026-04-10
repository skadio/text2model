% Parameters
int: costX = 5000;
int: costY = 7000;
int: costZ = 10000;

int: maxTotal = 50;

int: minX = 10;
int: minY = 15;
int: minZ = 20;

% Variables
var minX..maxTotal: X;
var minY..maxTotal: Y;
var minZ..maxTotal: Z;

var 0..(costX*maxTotal + costY*maxTotal + costZ*maxTotal): totalCost;

% Constraints
constraint X + Y + Z <= maxTotal;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;