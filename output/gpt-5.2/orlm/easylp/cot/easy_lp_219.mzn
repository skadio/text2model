% Parameters (with values embedded)
int: capacity = 500;
int: minX = 100;
int: minY = 80;
int: minZ = 120;

int: costX = 5;
int: costY = 4;
int: costZ = 6;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

var 0..(capacity * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= capacity;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;