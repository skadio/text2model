% Parameters
int: B = 1000;
int: minX = 300;
int: minY = 200;
int: minZ = 100;

int: cX = 500;
int: cY = 300;
int: cZ = 200;

% Variables
var minX..B: X;
var minY..B: Y;
var minZ..B: Z;

var 0..(cX*B + cY*B + cZ*B): TotalCost;

% Constraints
constraint X + Y + Z <= B;

constraint TotalCost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize TotalCost;