% Parameters
int: total_capacity = 500;

int: minX = 100;
int: minY = 150;
int: minZ = 200;

int: maxX = 300;
int: maxY = 400;
int: maxZ = 600;

int: costX = 5;
int: costY = 10;
int: costZ = 15;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var int: total_cost;

% Constraints
constraint X + Y + Z <= total_capacity;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;