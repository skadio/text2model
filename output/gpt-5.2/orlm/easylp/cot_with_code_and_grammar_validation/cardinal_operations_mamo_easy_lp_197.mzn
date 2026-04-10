% Parameters
int: budget = 50000;
int: diffXY = 10000;
int: diffYZ = 5000;

int: costX = 1000;
int: costY = 800;
int: costZ = 600;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..budget: z;

var 0..(budget * max([costX, costY, costZ])): total_cost;

% Constraints
constraint x + y + z <= budget;

constraint x >= y + diffXY;
constraint y >= z + diffYZ;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;