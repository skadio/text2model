% Parameters (with values embedded)
int: total_capacity = 100;
int: min_diff_XY = 10;
int: max_YZ = 70;

int: costX = 5;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..total_capacity: X;
var 0..total_capacity: Y;
var 0..total_capacity: Z;

% Constraints
constraint X + Y + Z <= total_capacity;
constraint X >= Y + min_diff_XY;
constraint Y + Z <= max_YZ;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;