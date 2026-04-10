% Parameters
int: BUDGET = 100;
int: minX = 30;
int: minY = 20;
int: minZ = 10;

int: costX = 20;
int: costY = 15;
int: costZ = 10;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(BUDGET * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= BUDGET;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;