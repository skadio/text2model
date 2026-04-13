% Parameters
int: B = 5000;
int: min_diff_XY = 1000;
int: max_diff_ZY = 1500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;
var 0..(costX*B + costY*B + costZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint X >= Y + min_diff_XY;

constraint abs(Z - Y) <= max_diff_ZY;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;