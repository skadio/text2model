% Parameters (with values embedded)
int: maxXY = 100;
int: maxXZ = 80;
int: minYZ = 70;

int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxXY: Z;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z <= maxXZ;
constraint Y + Z >= minYZ;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;