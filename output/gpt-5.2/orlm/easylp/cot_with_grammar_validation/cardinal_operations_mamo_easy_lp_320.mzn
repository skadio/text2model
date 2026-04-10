% Parameters
int: maxVehicles = 1000;
int: costX = 5;
int: costY = 4;
int: costZ = 6;
int: minX = 200;
int: minY = 150;
int: minZ = 300;

% Variables
var minX..maxVehicles: x;
var minY..maxVehicles: y;
var minZ..maxVehicles: z;
var 0..(costX*maxVehicles + costY*maxVehicles + costZ*maxVehicles): totalCost;

% Constraints
constraint x + y + z <= maxVehicles;
constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;