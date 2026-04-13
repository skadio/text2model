% Parameters
int: capacity = 500;

int: minX = 100;
int: minY = 80;
int: minZ = 120;

int: costX = 5;
int: costY = 4;
int: costZ = 6;

% Variables
var minX..capacity: X;
var minY..capacity: Y;
var minZ..capacity: Z;

var 0..(capacity * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= capacity;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;