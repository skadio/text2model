% Parameters
int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxTotal = 1000;
int: minTraffic = 500;          % 2*X + 3*Y >= 500
int: maxDemandExpr = 400;       % X + Z - Y <= 400
int: minYMinusZ = 100;          % Y >= Z + 100

% Variables
var 0..maxTotal: X;
var 0..maxTotal: Y;
var 0..maxTotal: Z;

var 0..(costX*maxTotal + costY*maxTotal + costZ*maxTotal): totalCost;

% Constraints
constraint X + Y + Z <= maxTotal;

constraint 2*X + 3*Y >= minTraffic;

constraint X + Z - Y <= maxDemandExpr;

constraint Y >= Z + minYMinusZ;

constraint totalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize totalCost;