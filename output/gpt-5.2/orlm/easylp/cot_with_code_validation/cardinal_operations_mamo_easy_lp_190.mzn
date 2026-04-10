% Parameters
int: capacity = 1000;
int: min_demand_X2Y = 500;
int: min_inventory_XZ = 400;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;
var 0..(costX*capacity + costY*capacity + costZ*capacity): total_cost;

% Constraints
constraint X + Y + Z <= capacity;
constraint 2*X + Y >= min_demand_X2Y;
constraint X + Z >= min_inventory_XZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;