% Parameters
int: budget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 250;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

% Variables
var int: X;
var int: Y;
var int: Z;

var int: totalCost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= budget;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;