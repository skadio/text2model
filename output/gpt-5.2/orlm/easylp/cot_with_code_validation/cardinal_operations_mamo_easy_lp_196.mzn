% Parameters
int: budget = 500;
int: minX = 100;
int: minY = 50;
int: minZ = 30;

int: costX = 1000;
int: costY = 1500;
int: costZ = 2000;

% Variables
var minX..budget: X;
var minY..budget: Y;
var minZ..budget: Z;

var 0..(budget * max(costX, max(costY, costZ))): totalCost;

% Constraints
constraint X + Y + Z <= budget;

constraint totalCost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize totalCost;