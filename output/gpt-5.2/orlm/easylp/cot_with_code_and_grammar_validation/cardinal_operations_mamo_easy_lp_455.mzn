% Parameters
int: minX = 0;
int: maxX = 5;
int: minY = 0;
int: maxY = 4;

int: costX = 5000;
int: costY = 7000;

int: strengthReq = 10;
int: maxTotalProjects = 8;

% Variables
var minX..maxX: X;
var minY..maxY: Y;
var int: totalCost;

% Constraints
constraint 2 * X + 3 * Y >= strengthReq;
constraint X + Y <= maxTotalProjects;
constraint Y >= X + 1;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;