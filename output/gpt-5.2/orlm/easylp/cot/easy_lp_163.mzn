% Parameters (with values embedded)
int: costX = 50000;
int: costY = 80000;

int: totalLimit = 10;
int: maxX = 7;
int: maxY = 6;

% Variables
var 0..maxX: X;
var 0..maxY: Y;

var int: totalCost;

% Constraints
constraint X + Y <= totalLimit;

% X must be at least half of Y plus 3: X >= Y/2 + 3  <=>  2X >= Y + 6
constraint 2 * X >= Y + 6;

constraint totalCost = costX * X + costY * Y;

% Objective
solve minimize totalCost;