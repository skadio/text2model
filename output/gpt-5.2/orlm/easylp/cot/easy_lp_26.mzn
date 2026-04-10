% Parameters (with values embedded)
int: minX = 300;
int: minY = 200;
int: maxTotal = 1000;
int: costX = 2;
int: costY = 3;

% Variables
var minX..maxTotal: X;
var minY..maxTotal: Y;
var 0..(costX*maxTotal + costY*maxTotal): total_cost;

% Constraints
constraint X >= minX;
constraint Y >= minY;
constraint X + Y <= maxTotal;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;