% Parameters (with values embedded)
int: costX = 1000;
int: costY = 500;
int: costZ = 1200;

int: totalLimit = 100;

int: minXOverY = 10;
int: maxZOverY = 20;

int: minX = 0; int: maxX = 50;
int: minY = 0; int: maxY = 40;
int: minZ = 0; int: maxZ = 60;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;

% Constraints
constraint X + Y + Z <= totalLimit;
constraint X >= Y + minXOverY;
constraint Z <= Y + maxZOverY;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;