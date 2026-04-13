% Parameters (with values embedded)
int: costX = 100;
int: costY = 50;

int: fertPerAcreX = 3;
int: fertPerAcreY = 2;
int: fertCap = 1000;

int: minTotalAcres = 200;
int: maxDiffAcres = 300;

int: maxX = 500;
int: maxY = 400;

% Variables
var 0..maxX: acresX;
var 0..maxY: acresY;

var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint fertPerAcreX * acresX + fertPerAcreY * acresY <= fertCap;
constraint acresX + acresY >= minTotalAcres;
constraint abs(acresX - acresY) <= maxDiffAcres;

constraint totalCost = costX * acresX + costY * acresY;

% Objective
solve minimize totalCost;