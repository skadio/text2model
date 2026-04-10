% Parameters
int: minX = 300;
int: minY = 200;
int: maxTotal = 1000;
int: costX = 2;
int: costY = 3;

% Variables
var minX..maxTotal: X;
var minY..maxTotal: Y;
var 0..(costX*maxTotal + costY*maxTotal): totalCost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint X + Y <= maxTotal;
constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;