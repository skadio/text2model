% Parameters
int: B = 1000;
int: cX = 20;
int: cY = 30;
int: cZ = 40;

int: rhs1 = 300;
int: rhs2 = 200;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint 2*X - Y + Z >= rhs1;

constraint X - 3*Y - Z = rhs2;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;