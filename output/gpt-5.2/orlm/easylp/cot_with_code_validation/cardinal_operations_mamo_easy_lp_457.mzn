% Parameters
int: costX = 5000;
int: costY = 8000;

int: maxTotal = 100;
int: minDiffXY = 20;
int: maxWeighted = 150;

% Variables
var 0..maxTotal: X;
var 0..maxTotal: Y;

var 0..(costX*maxTotal + costY*maxTotal): total_cost;

% Constraints
constraint X + Y <= maxTotal;
constraint X - Y >= minDiffXY;
constraint X + 2 * Y <= maxWeighted;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;