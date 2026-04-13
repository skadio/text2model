% Parameters
int: TOTAL = 100;
int: minX = 20;
int: minY = 15;
int: minZ = 10;

int: costX = 50;
int: costY = 80;
int: costZ = 30;

% Variables
var minX..TOTAL: x;
var minY..TOTAL: y;
var minZ..TOTAL: z;

var 0..(TOTAL * max([costX, costY, costZ])): total_cost;

% Constraints
constraint x + y + z = TOTAL;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;