% Parameters
int: budget = 1000;
int: cX = 5;
int: cY = 6;
int: cZ = 7;

int: maxX = 500;
int: maxY = 400;
int: minZ = 50;

int: rhs1 = 10;   % 3X + 2Y - Z >= 10
int: rhs2 = 30;   % Z - Y >= 30

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(cX*maxX + cY*maxY + cZ*budget): total_cost;

% Constraints
constraint X <= maxX;
constraint Y <= maxY;
constraint Z >= minZ;

constraint X + Y + Z <= budget;

constraint 3*X + 2*Y - Z >= rhs1;
constraint Z - Y >= rhs2;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;