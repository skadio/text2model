% Parameters (with values embedded)
int: budget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= budget;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;