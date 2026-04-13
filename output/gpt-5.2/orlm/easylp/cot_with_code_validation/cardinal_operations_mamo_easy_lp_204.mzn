% Parameters
int: budget = 1000;
int: minX = 300;
int: maxY = 500;
int: minZ = 200;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 300..1000: X;
var 0..500: Y;
var 200..1000: Z;

var 0..(costX*1000 + costY*500 + costZ*1000): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;