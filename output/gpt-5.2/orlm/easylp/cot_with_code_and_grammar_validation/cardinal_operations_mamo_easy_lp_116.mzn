% Parameters
int: capacity = 100;
int: maxX = 70;
int: maxY = 50;
int: costX = 50;
int: costY = 80;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint x + y <= capacity;

% x must be at least 10 more than twice y: x >= 2y + 10
constraint x >= 2*y + 10;

% (y - x/2) <= 20  -> avoid halves: 2y - x <= 40
constraint 2*y - x <= 40;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;