% Parameters
int: costX = 5;
int: costY = 10;
int: costZ = 7;

int: totalResourcesMax = 1000;

int: minX = 200;
int: maxY = 400;
int: minZ = 150;

% Variables
var 0..totalResourcesMax: x;
var 0..totalResourcesMax: y;
var 0..totalResourcesMax: z;

var 0..(totalResourcesMax * max([costX, costY, costZ])): totalCost;

% Constraints
constraint x >= minX;
constraint y <= maxY;
constraint z >= minZ;

constraint x + y + z <= totalResourcesMax;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;