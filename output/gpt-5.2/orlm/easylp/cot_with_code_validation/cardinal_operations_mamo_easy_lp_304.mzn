% Parameters
int: B = 1000;          % total budget limit for allocations
int: min_excess_X = 200; % X must exceed 2*Y by at least this amount
int: min_excess_Z = 100; % Z must exceed Y by at least this amount

int: cX = 2;
int: cY = 3;
int: cZ = 1;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(cX*B + cY*B + cZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint X >= 2*Y + min_excess_X;
constraint Z >= Y + min_excess_Z;

constraint total_cost = cX*X + cY*Y + cZ*Z;

% Objective
solve minimize total_cost;