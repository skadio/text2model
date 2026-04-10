% Parameters
int: capacity = 300;
int: demand = 800;

int: costX = 50;
int: costY = 70;

int: aX = 3;
int: aY = 4;

% Variables
var 0..capacity: x;
var 0..capacity: y;
var 0..(costX*capacity + costY*capacity): totalCost;

% Constraints
constraint x + y <= capacity;
constraint aX*x + aY*y >= demand;
constraint x >= y;

constraint totalCost = costX*x + costY*y;

% Objective
solve minimize totalCost;