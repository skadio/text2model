% Parameters
int: BUDGET = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

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