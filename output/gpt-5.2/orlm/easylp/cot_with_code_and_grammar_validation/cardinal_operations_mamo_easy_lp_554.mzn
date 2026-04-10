% Parameters
int: MAX_TOTAL = 100;
int: minX = 20;
int: minY = 30;
int: minZ = 10;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Variables
var 0..MAX_TOTAL: x;
var 0..MAX_TOTAL: y;
var 0..MAX_TOTAL: z;

var 0..(MAX_TOTAL * max([costX, costY, costZ])): total_cost;

% Constraints
constraint x + y + z <= MAX_TOTAL;

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;