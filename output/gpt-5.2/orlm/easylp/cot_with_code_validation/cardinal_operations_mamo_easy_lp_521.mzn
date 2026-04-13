% Parameters
int: costX = 7;
int: costY = 3;
int: costZ = 5;

int: minDiversification = 10;
int: maxRiskExposure = 15;
int: xMoreThanY = 3;
int: maxTotal = 20;

% Variables
var 0..maxTotal: X;
var 0..maxTotal: Y;
var 0..maxTotal: Z;

var 0..(costX*maxTotal + costY*maxTotal + costZ*maxTotal): totalCost;

% Constraints
constraint 2*X + Y + Z >= minDiversification;
constraint X - Y + 2*Z <= maxRiskExposure;
constraint X = Y + xMoreThanY;
constraint X + Y + Z <= maxTotal;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;