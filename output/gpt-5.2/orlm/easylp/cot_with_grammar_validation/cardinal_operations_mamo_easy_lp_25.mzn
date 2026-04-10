% Parameters
int: costX = 5;
int: costY = 10;
int: minX = 30;
int: minY = 20;
int: maxTotal = 100;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;

% Constraints
constraint x + y <= maxTotal;

% Objective
solve minimize costX * x + costY * y;