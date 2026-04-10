% Parameters
int: aX = 2;
int: aY = 3;
int: cap = 50;

int: bX = 5;
int: bY = 1;
int: minStrength = 10;

int: diffLimit = 5;

int: costX = 10; % in thousands
int: costY = 20; % in thousands

% Variables
var 0..cap: x;
var 0..cap: y;
var 0..(costX*cap + costY*cap): totalCost;

% Constraints
constraint aX * x + aY * y <= cap;
constraint bX * x + bY * y >= minStrength;
constraint x - y <= diffLimit;
constraint y - x <= diffLimit;

constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;