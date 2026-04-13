% Parameters
int: costX = 50;
int: costY = 70;
int: maxTotal = 1000;
int: minX = 300;
int: minY = 200;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;
var 0..(costX*maxTotal + costY*maxTotal): totalCost;

% Constraints
constraint x + y <= maxTotal;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;