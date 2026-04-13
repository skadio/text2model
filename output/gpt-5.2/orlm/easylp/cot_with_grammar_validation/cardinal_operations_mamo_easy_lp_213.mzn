% Parameters
int: total_capacity = 100;
int: minX = 10;
int: minY = 20;
int: minZ = 15;

int: costX = 30;
int: costY = 20;
int: costZ = 50;

% Variables
var minX..total_capacity: X;
var minY..total_capacity: Y;
var minZ..total_capacity: Z;

var 0..(costX*total_capacity + costY*total_capacity + costZ*total_capacity): total_cost;

% Constraints
constraint X + Y + Z <= total_capacity;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;