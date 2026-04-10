% Parameters (with values embedded)
int: costX = 300000;
int: costY = 200000;
int: maxTotal = 10;
int: ratio = 5; % X >= 5 * Y

% Variables
var 1..maxTotal: X;
var 1..maxTotal: Y;

% Constraints
constraint X + Y <= maxTotal;
constraint X >= ratio * Y;

% Objective
solve minimize costX * X + costY * Y;