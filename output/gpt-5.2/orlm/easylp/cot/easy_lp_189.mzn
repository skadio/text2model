% Parameters (with values embedded)
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxXY = 5000;
int: maxYZ = 4000;
int: minXZ = 2000;

% Variables
var 0..5000: X;
var 0..5000: Y;
var 0..4000: Z;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;