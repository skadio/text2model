% Parameters (with values embedded)
int: costX = 500;
int: costY = 300;
int: maxTotalStudents = 25;
int: minX = 10;
int: minY = 5;

% Variables
var 0..maxTotalStudents: x; % students in Program X
var 0..maxTotalStudents: y; % students in Program Y
var 0..(costX*maxTotalStudents + costY*maxTotalStudents): totalCost;

% Constraints
constraint x + y <= maxTotalStudents;
constraint x >= minX;
constraint y >= minY;
constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;