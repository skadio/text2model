% Parameters
int: prodX = 60;
int: prodY = 90;

int: aX = 2;
int: aY = 3;
int: cap = 1200;

int: minTotalAlloc = 100;

% Variables
var 0..cap div aX: x;
var 0..cap div aY: y;
var 0..(prodX*(cap div aX) + prodY*(cap div aY)): totalPower;

% Constraints
constraint aX * x + aY * y <= cap;
constraint x >= y;
constraint x + y >= minTotalAlloc;

constraint totalPower = prodX * x + prodY * y;

% Objective
solve minimize totalPower;