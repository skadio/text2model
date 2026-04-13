% Parameters
int: costX = 500;
int: costY = 300;
int: maxTotalStudents = 25;
int: minX = 10;
int: minY = 5;

% Variables
var minX..maxTotalStudents: x;
var minY..maxTotalStudents: y;
var 0..(costX*maxTotalStudents + costY*maxTotalStudents): totalCost;

% Constraints
constraint x + y <= maxTotalStudents;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;