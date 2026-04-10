% Parameters
int: BUDGET = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 250;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(BUDGET * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;