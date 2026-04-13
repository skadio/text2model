% Parameters
int: costX = 5000;
int: costY = 6000;
int: costZ = 7000;

int: totalMax = 100;

int: capX = 50;
int: capY = 30;
int: capZ = 20;

int: offsetXY = 10;
int: multYinX = 2;

int: offsetYZ = 5;

% Variables
var 0..capX: x;
var 0..capY: y;
var 0..capZ: z;

var 0..(costX*capX + costY*capY + costZ*capZ): totalCost;

% Constraints
constraint x + y + z <= totalMax;

constraint x >= offsetXY + multYinX * y;
constraint y >= offsetYZ + z;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;