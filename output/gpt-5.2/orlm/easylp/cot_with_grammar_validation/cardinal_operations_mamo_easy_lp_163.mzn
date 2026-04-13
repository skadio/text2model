% Parameters
int: costX = 50000;
int: costY = 80000;

int: total_limit = 10;

int: maxX = 7;
int: maxY = 6;

% Variables
var 0..maxX: X;
var 0..maxY: Y;

var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint X + Y <= total_limit;

% "X must be at least half of Y plus 3"  =>  X >= Y/2 + 3
% Avoid fractions: 2X >= Y + 6
constraint 2 * X >= Y + 6;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;