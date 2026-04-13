% Parameters
int: costX = 5000;
int: costY = 8000;

int: maxTotalUnits = 100;
int: minDiffXY = 20;      % X - Y >= 20
int: maxWeightedUnits = 150; % X + 2Y <= 150

% Variables
var 0..maxTotalUnits: X;
var 0..maxTotalUnits: Y;

var 0..(costX*maxTotalUnits + costY*maxTotalUnits): totalCost;

% Constraints
constraint X + Y <= maxTotalUnits;
constraint X - Y >= minDiffXY;
constraint X + 2*Y <= maxWeightedUnits;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;