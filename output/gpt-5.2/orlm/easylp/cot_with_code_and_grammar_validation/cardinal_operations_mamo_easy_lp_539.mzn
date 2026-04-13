% Parameters
int: BUDGET = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: maxExcessXoverY = 50;
int: minExcessYoverZ = 20;

int: costX = 300;
int: costY = 500;
int: costZ = 200;

% Variables
var minX..BUDGET: x;
var minY..BUDGET: y;
var minZ..BUDGET: z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint x + y + z <= BUDGET;

constraint x - y <= maxExcessXoverY;
constraint y - z >= minExcessYoverZ;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;