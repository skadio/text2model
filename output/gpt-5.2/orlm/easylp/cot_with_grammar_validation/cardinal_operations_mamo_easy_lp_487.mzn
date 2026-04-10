% Parameters
int: costX = 20;
int: costY = 30;

int: maxTotal = 1000;
int: minDiff = 200;
int: maxWeighted = 1500;

int: maxX = 800;
int: maxY = 600;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint x + y <= maxTotal;
constraint abs(x - y) >= minDiff;
constraint 2*x + y <= maxWeighted;

constraint totalCost = costX*x + costY*y;

% Objective
solve minimize totalCost;