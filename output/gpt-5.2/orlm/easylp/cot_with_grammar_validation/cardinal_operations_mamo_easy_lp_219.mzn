% Parameters
int: capacity = 500;
int: minX = 100;
int: minY = 80;
int: minZ = 120;

int: costX = 5;
int: costY = 4;
int: costZ = 6;

% Variables
var minX..capacity: x;
var minY..capacity: y;
var minZ..capacity: z;

var 0..(costX*capacity + costY*capacity + costZ*capacity): total_cost;

% Constraints
constraint x + y + z <= capacity;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;