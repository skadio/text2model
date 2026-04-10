% Parameters
int: costX = 50;
int: costY = 70;

int: contribX = 5;
int: contribY = 10;

int: minTotalContrib = 100;
int: maxBuildings = 20;

% Variables
var 0..maxBuildings: x;
var 0..maxBuildings: y;
var 0..(costX*maxBuildings + costY*maxBuildings): totalCost;

% Constraints
constraint contribX * x + contribY * y >= minTotalContrib;
constraint x + y <= maxBuildings;

constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;