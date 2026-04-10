% Parameters
int: B = 5000;
int: cX = 20;
int: cY = 15;
int: cZ = 30;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

% Constraints
constraint X + Y + Z <= B;

constraint X >= 2000 - 3 * Y;
constraint Z >= 1000 + Y;

% Objective
var int: total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;