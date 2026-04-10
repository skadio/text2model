% Parameters
int: budget = 1000;
int: minX = 300;
int: maxY = 500;
int: minZ = 200;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint X >= minX;
constraint Y <= maxY;
constraint Z >= minZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;