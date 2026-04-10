% Parameters
int: costX = 50;
int: costY = 70;
int: maxContainers = 1000;
int: minX = 300;
int: minY = 200;

% Variables
var minX..maxContainers: x;
var minY..maxContainers: y;
var 0..(costX * maxContainers + costY * maxContainers): totalCost;

% Constraints
constraint x + y <= maxContainers;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;