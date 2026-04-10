% Parameters
int: costX = 5;
int: costY = 10;
int: minX = 30;
int: minY = 20;
int: maxTotal = 100;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;
var 0..(costX*maxTotal + costY*maxTotal): totalCost;

% Constraints
constraint x >= minX;
constraint y >= minY;
constraint x + y <= maxTotal;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;