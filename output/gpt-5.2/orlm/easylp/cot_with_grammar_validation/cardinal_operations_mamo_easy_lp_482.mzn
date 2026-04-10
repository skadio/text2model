% Parameters
int: minX = 10;
int: minY = 5;
int: maxTotal = 40;
int: outX = 50;
int: outY = 30;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;
var 0..(outX * maxTotal + outY * maxTotal): totalOutcome;

% Constraints
constraint x + y <= maxTotal;
constraint totalOutcome = outX * x + outY * y;

% Objective
solve maximize totalOutcome;