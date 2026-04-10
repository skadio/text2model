% Parameters
int: minX = 10;
int: minY = 5;
int: maxTotal = 40;
int: outcomeX = 50;
int: outcomeY = 30;

% Variables
var minX..maxTotal: x;
var minY..maxTotal: y;
var 0..(outcomeX*maxTotal + outcomeY*maxTotal): total_outcome;

% Constraints
constraint x + y <= maxTotal;
constraint total_outcome = outcomeX * x + outcomeY * y;

% Objective
solve maximize total_outcome;