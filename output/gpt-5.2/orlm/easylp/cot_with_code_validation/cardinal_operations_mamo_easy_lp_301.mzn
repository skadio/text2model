% Parameters
int: costX = 5;
int: costY = 3;
int: costZ = 2;

int: maxXY = 20;
int: min2YZ = 10;
int: maxXZ = 15;

% Variables
var 0..max(maxXY, maxXZ): X;
var 0..maxXY: Y;
var 0..maxXZ: Z;

var int: total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint 2 * Y + Z >= min2YZ;
constraint X + Z <= maxXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;