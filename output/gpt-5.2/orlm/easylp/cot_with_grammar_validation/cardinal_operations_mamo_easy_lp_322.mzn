% Parameters
int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxXY = 20;
int: minYZ = 30;
int: maxDiffXZ = 10;

% Variables
var 0..maxXY: x;
var 0..maxXY: y;
var 0..(minYZ + maxDiffXZ): z;

var int: total_cost;

% Constraints
constraint x + y <= maxXY;
constraint y + z >= minYZ;
constraint abs(x - z) <= maxDiffXZ;

% total cost definition
constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;