% Parameters
int: costX = 100;
int: costY = 50;

int: fertPerAcreX = 3;
int: fertPerAcreY = 2;
int: fertMax = 1000;

int: minTotalAcres = 200;

int: maxDiffAcres = 300;

int: maxAcresX = 500;
int: maxAcresY = 400;

% Variables
var 0..maxAcresX: acresX;
var 0..maxAcresY: acresY;

var 0..(costX*maxAcresX + costY*maxAcresY): totalCost;

% Constraints
constraint fertPerAcreX * acresX + fertPerAcreY * acresY <= fertMax;

constraint acresX + acresY >= minTotalAcres;

constraint abs(acresX - acresY) <= maxDiffAcres;

constraint totalCost = costX * acresX + costY * acresY;

% Objective
solve minimize totalCost;