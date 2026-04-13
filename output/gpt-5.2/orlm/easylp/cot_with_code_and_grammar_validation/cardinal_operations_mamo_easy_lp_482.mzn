% Parameters
int: minX = 10;
int: minY = 5;
int: maxTotal = 40;
int: gainX = 50;
int: gainY = 30;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;
var 0..(gainX*maxTotal + gainY*maxTotal): outcome;

% Constraints
constraint x + y <= maxTotal;
constraint outcome = gainX * x + gainY * y;

% Objective
solve maximize outcome;