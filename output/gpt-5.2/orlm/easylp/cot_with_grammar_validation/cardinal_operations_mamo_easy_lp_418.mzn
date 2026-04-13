% Parameters
int: pX = 60;
int: pY = 90;

int: aX = 2;
int: aY = 3;
int: cap = 1200;

int: minTotalAlloc = 100;

% Variables
var 0..cap: x;
var 0..cap: y;

var 0..(pX*cap + pY*cap): totalPower;

% Constraints
constraint aX * x + aY * y <= cap;
constraint x >= y;
constraint x + y >= minTotalAlloc;

constraint totalPower = pX * x + pY * y;

% Objective
solve minimize totalPower;