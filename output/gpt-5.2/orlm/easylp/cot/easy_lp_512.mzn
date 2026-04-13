% Parameters (with values embedded)
int: capacity = 1000;
int: demand_min = 300;
int: material_max = 600;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

var 0..(costX*capacity + costY*capacity + costZ*capacity): total_cost;

% Constraints
constraint X + Y + Z <= capacity;

constraint 2*X + Y >= demand_min;

constraint X + 3*Z <= material_max;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;