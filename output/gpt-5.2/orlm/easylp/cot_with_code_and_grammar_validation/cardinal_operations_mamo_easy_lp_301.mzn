% Parameters
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 20;
int: min2YplusZ = 10;
int: maxXZ = 15;

% Variables
var 0..max(maxXY, maxXZ): x;
var 0..maxXY: y;
var 0..maxXZ: z;

var 0..(costX*max(maxXY, maxXZ) + costY*maxXY + costZ*maxXZ): total_cost;

% Constraints
constraint x + y <= maxXY;
constraint 2*y + z >= min2YplusZ;
constraint x + z <= maxXZ;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;