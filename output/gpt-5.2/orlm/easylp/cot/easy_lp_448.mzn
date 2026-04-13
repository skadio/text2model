% Parameters (with values embedded)
int: costX = 50;
int: costY = 100;

int: totalCap = 2000;
int: diffMin = 500;
int: minX = 750;

% Variables
var 0..totalCap: X;
var 0..totalCap: Y;

% Constraints
constraint X + Y <= totalCap;
constraint X - 2 * Y >= diffMin;
constraint X >= minX;

% Objective
var int: totalCost = costX * X + costY * Y;
solve minimize totalCost;