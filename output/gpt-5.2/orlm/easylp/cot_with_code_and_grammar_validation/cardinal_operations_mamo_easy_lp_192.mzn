% Parameters
int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxTotal = 50;
int: minXminusY = 10;
int: maxYplusZ = 40;

int: maxX = 20;
int: maxY = 30;
int: maxZ = 25;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): totalCost;

% Constraints
constraint x + y + z <= maxTotal;

constraint x >= y + minXminusY;

constraint y + z <= maxYplusZ;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;