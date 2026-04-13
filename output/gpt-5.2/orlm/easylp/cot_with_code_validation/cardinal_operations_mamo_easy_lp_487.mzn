% Parameters
int: costX = 20;
int: costY = 30;

int: totalCap = 1000;
int: diffMin = 200;
int: mixCap = 1500;

int: maxX = 800;
int: maxY = 600;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..(costX*maxX + costY*maxY): totalCost;

% Constraints
constraint x + y <= totalCap;
constraint abs(x - y) >= diffMin;
constraint 2*x + y <= mixCap;

constraint totalCost = costX*x + costY*y;

% Objective
solve minimize totalCost;