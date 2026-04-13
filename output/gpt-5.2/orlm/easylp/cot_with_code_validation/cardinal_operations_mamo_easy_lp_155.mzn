% Parameters
int: costX = 300000;
int: costY = 200000;
int: maxTotal = 10;
int: ratio = 5;

% Variables
var 1..maxTotal: x;
var 1..maxTotal: y;
var 0..(costX*maxTotal + costY*maxTotal): totalCost;

% Constraints
constraint x + y <= maxTotal;
constraint x >= ratio * y;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;