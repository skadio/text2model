% Parameters (with values embedded)
int: total_limit = 1000;
int: min_strength = 400;
int: yz_limit = 600;

int: costX = 4;
int: costY = 3;
int: costZ = 5;

% Variables
var 0..total_limit: X;
var 0..total_limit: Y;
var 0..total_limit: Z;

% Constraints
constraint X + Y + Z <= total_limit;
constraint 2 * X + Y >= min_strength;
constraint Y + Z <= yz_limit;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;