% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 6;

int: totalVehiclesMax = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 300;

% Variables
var minX..totalVehiclesMax: x;
var minY..totalVehiclesMax: y;
var minZ..totalVehiclesMax: z;

var 0..(costX*totalVehiclesMax + costY*totalVehiclesMax + costZ*totalVehiclesMax): totalCost;

% Constraints
constraint x + y + z <= totalVehiclesMax;

constraint totalCost = costX * x + costY * y + costZ * z;

% Objective
solve minimize totalCost;