% Parameters
int: B = 1000;
int: minX = 200;
int: minY = 100;
int: minZ = 50;
int: cX = 2;
int: cY = 3;
int: cZ = 4;

% Variables
var minX..B: x;
var minY..B: y;
var minZ..B: z;
var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint x + y + z <= B;

constraint total_cost = cX*x + cY*y + cZ*z;

% Objective
solve minimize total_cost;