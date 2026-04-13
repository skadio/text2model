% Parameters
int: costX = 100;
int: costY = 50;

int: fertX = 3;
int: fertY = 2;
int: fertMax = 1000;

int: minTotalAcre = 200;
int: maxDiff = 300;

int: maxX = 500;
int: maxY = 400;

% Variables
var 0..maxX: x;  % acres of crop X (integer)
var 0..maxY: y;  % acres of crop Y (integer)

var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint fertX * x + fertY * y <= fertMax;
constraint x + y >= minTotalAcre;
constraint abs(x - y) <= maxDiff;

constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;