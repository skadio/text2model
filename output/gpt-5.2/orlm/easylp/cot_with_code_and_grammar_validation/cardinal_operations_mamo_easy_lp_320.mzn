% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 6;

int: totalVehiclesMax = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 300;

% Variables
var 0..totalVehiclesMax: x;
var 0..totalVehiclesMax: y;
var 0..totalVehiclesMax: z;

var 0..(costX*totalVehiclesMax + costY*totalVehiclesMax + costZ*totalVehiclesMax): totalCost;

% Constraints
constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint x + y + z <= totalVehiclesMax;

constraint totalCost = costX*x + costY*y + costZ*z;

% Objective
solve minimize totalCost;