% Parameters
int: costX = 4;
int: costY = 3;
int: costZ = 2;

int: maxXY = 25;
int: minXZ = 15;
int: maxYZ = 20;

% Variables
var 0..max(maxXY, minXZ): X;
var 0..max(max(maxXY, maxYZ), minXZ): Y;
var 0..max(max(maxXY, maxYZ), minXZ): Z;

var int: total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint Y + Z <= maxYZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;