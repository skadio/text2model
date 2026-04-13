% Parameters
int: minX = 10;
int: minY = 5;
int: maxTotal = 40;
int: costX = 50;
int: costY = 80;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;
var 0..(costX*maxTotal + costY*maxTotal): totalCost;

% Constraints
constraint x + y <= maxTotal;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;