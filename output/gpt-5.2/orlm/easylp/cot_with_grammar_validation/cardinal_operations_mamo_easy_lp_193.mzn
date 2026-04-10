% Parameters
int: maxVehicles = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 150;

int: costX = 3;
int: costY = 2;
int: costZ = 5;

% Variables
var 0..maxVehicles: x;
var 0..maxVehicles: y;
var 0..maxVehicles: z;

var 0..(maxVehicles * max([costX, costY, costZ])): totalCost;

% Constraints
constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint x + y + z <= maxVehicles;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;