% Parameters
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 50;

% Variables
var 0..maxXY: x;
var 0..maxXY: y;
var 0..maxYZ: z;

% Constraints
constraint x + y <= maxXY;
constraint y + z <= maxYZ;
constraint x + z >= minXZ;

% Objective
var int: total_cost = costX * x + costY * y + costZ * z;
solve minimize total_cost;