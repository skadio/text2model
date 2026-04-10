% Parameters (with values embedded)
int: budget = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 120;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..budget: z;

var 0..(budget * max([costX, costY, costZ])): total_cost;

% Constraints
constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint x + y + z <= budget;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;