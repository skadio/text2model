% Parameters
int: budget = 1000;
int: minX = 300;
int: minY = 200;
int: minZ = 100;

int: costX = 500;
int: costY = 300;
int: costZ = 200;

% Variables
var minX..budget: x;
var minY..budget: y;
var minZ..budget: z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint x + y + z <= budget;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;