% Parameters
int: CAPACITY = 1000;
int: DEMAND_MIN = 300;
int: MATERIAL_MAX = 600;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..CAPACITY: X;
var 0..CAPACITY: Y;
var 0..CAPACITY: Z;

var 0..(costX*CAPACITY + costY*CAPACITY + costZ*CAPACITY): TotalCost;

% Constraints
constraint X + Y + Z <= CAPACITY;

constraint 2*X + Y >= DEMAND_MIN;

constraint X + 3*Z <= MATERIAL_MAX;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;