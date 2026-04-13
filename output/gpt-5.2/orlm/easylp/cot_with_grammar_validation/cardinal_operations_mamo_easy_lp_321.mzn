% Parameters
int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxX = 100;
int: maxY = 80;
int: maxZ = 60;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint 2*x + 3*y + z >= 30;
constraint x + 4*y + 2*z <= 50;
constraint x - y + z >= 10;

constraint total_cost = costX*x + costY*y + costZ*z;

% Objective
solve minimize total_cost;