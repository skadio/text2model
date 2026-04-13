% Parameters
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxXY = 5000;
int: maxYZ = 4000;
int: minXZ = 2000;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxYZ: Z;

var int: total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;