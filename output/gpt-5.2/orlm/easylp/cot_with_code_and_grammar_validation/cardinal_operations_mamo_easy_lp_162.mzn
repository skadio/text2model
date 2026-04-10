% Parameters
int: costX = 200000;
int: costY = 300000;
int: maxTotal = 10;
int: ratio = 3; % X >= ratio * Y
int: minEach = 1;

% Variables
var 0..maxTotal: x; % properties at location X
var 0..maxTotal: y; % properties at location Y
var int: totalCost;

% Constraints
constraint x + y <= maxTotal;
constraint x >= ratio * y;
constraint x >= minEach;
constraint y >= minEach;

constraint totalCost = costX * x + costY * y;

% Objective
solve minimize totalCost;