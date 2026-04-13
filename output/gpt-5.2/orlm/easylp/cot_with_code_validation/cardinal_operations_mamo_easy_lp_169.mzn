% Parameters
int: B = 1000;
int: minX = 200;
int: minY = 100;
int: minZ = 50;

int: cX = 2;
int: cY = 3;
int: cZ = 4;

% Variables
var minX..B: X;
var minY..B: Y;
var minZ..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;