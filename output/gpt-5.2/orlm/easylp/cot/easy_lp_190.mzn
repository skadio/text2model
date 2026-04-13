% Parameters (with values embedded)
int: capacity = 1000;
int: min_demand_X2Y = 500;   % 2*X + Y >= 500
int: min_balance_XZ = 400;   % X + Z >= 400

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

% Constraints
constraint X + Y + Z <= capacity;
constraint 2 * X + Y >= min_demand_X2Y;
constraint X + Z >= min_balance_XZ;

% Objective
solve minimize costX * X + costY * Y + costZ * Z;