% Parameters
int: B = 1000;
int: rhs1 = 200;
int: rhs2 = 500;

int: cX = 50;
int: cY = 30;
int: cZ = 20;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;
constraint X - 2*Y + Z >= rhs1;
constraint 2*X + Y - Z <= rhs2;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;