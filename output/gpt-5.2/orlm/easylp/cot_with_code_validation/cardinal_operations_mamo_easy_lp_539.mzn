% Parameters
int: budget = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: maxDiffXY = 50;     % X should not exceed Y by more than 50: X - Y <= 50
int: minDiffYZ = 20;     % Y should be at least 20 more than Z: Y - Z >= 20

int: costX = 300;
int: costY = 500;
int: costZ = 200;

% Variables
var minX..budget: x;
var minY..budget: y;
var minZ..budget: z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint x + y + z <= budget;

constraint x - y <= maxDiffXY;
constraint y - z >= minDiffYZ;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;