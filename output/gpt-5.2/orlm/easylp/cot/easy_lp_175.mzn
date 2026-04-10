% Parameters (with values embedded)
int: max_XY = 100;
int: min_XZ = 150;
int: max_YZ = 200;

int: costX = 3;
int: costY = 4;
int: costZ = 5;

% Variables
var 0..200: X;
var 0..200: Y;
var 0..200: Z;

% Constraints
constraint X + Y <= max_XY;
constraint X + Z >= min_XZ;
constraint Y + Z <= max_YZ;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;