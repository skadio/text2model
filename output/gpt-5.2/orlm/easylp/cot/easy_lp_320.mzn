% Parameters (with values embedded)
int: costX = 5;
int: costY = 4;
int: costZ = 6;

int: totalVehicles = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 300;

% Variables
var 0..totalVehicles: x; % vehicles on route X
var 0..totalVehicles: y; % vehicles on route Y
var 0..totalVehicles: z; % vehicles on route Z

var 0..(costX*totalVehicles + costY*totalVehicles + costZ*totalVehicles): totalCost;

% Constraints
constraint x + y + z <= totalVehicles;

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;