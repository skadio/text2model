% Parameters (with values embedded)
int: costX = 50;
int: costY = 70;
int: demand = 5000;
int: emissionLimit = 80000;
int: emissionX = 10;
int: emissionY = 15;

% Variables
var 0..demand: X;
var 0..demand: Y;
var 0..(costX*demand + costY*demand): totalCost;

% Constraints
constraint X + Y >= demand;
constraint emissionX * X + emissionY * Y <= emissionLimit;
constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;