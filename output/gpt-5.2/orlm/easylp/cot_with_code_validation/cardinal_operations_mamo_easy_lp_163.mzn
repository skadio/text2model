% Parameters
int: costX = 50000;
int: costY = 80000;
int: maxTotal = 10;
int: maxX = 7;
int: maxY = 6;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(maxX + maxY): totalUnits;
var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint totalUnits = X + Y;
constraint totalUnits <= maxTotal;

% X must be at least half of Y plus 3:  X >= Y/2 + 3  <=>  2X >= Y + 6
constraint 2 * X >= Y + 6;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;