% Parameters
int: costX = 5000;
int: costY = 3000;

int: maxTotalHours = 20;

int: minExprRHS = 5;          % 3*X - 4*Y >= 5
int: eqRHS = 10;              % 2*X + Y == 10

int: xLB = 0;
int: xUB = 15;
int: yLB = 0;
int: yUB = 10;

% Variables
var xLB..xUB: x;              % hours for Project X
var yLB..yUB: y;              % hours for Project Y

var 0..(costX*xUB + costY*yUB): totalCost;

% Constraints
constraint x + y <= maxTotalHours;
constraint 3*x - 4*y >= minExprRHS;
constraint 2*x + y = eqRHS;

constraint totalCost = costX*x + costY*y;

% Objective
solve minimize totalCost;