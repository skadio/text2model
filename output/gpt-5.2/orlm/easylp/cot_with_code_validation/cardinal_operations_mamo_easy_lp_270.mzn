% Parameters
int: costX = 5000;
int: costY = 6000;
int: costZ = 7000;

int: maxTotal = 100;
int: maxX = 50;
int: maxY = 30;
int: maxZ = 20;

int: offsetXY = 10;
int: multYinX = 2;
int: offsetYZ = 5;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;

% Constraints
constraint x + y + z <= maxTotal;

constraint x >= offsetXY + multYinX * y;
constraint y >= offsetYZ + z;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;