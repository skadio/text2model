% Parameters
int: costX = 50;
int: costY = 100;

int: maxTotal = 2000;
int: minDiff = 500;      % X - 2*Y >= 500
int: minX = 750;

% Variables
var 0..maxTotal: X;
var 0..maxTotal: Y;
var 0..(costX*maxTotal + costY*maxTotal): totalCost;

% Constraints
constraint X + Y <= maxTotal;
constraint X - 2*Y >= minDiff;
constraint X >= minX;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;