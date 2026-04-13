% Parameters
int: costX = 2;
int: costY = 3;
int: maxTotalUnits = 1000;
int: minX = 200;
int: minY = 300;

% Variables
var 0..maxTotalUnits: x;
var 0..maxTotalUnits: y;

% Constraints
constraint x + y <= maxTotalUnits;
constraint x >= minX;
constraint y >= minY;

% Objective
solve minimize costX * x + costY * y;