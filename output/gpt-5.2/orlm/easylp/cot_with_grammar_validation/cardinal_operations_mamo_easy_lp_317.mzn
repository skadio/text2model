% Parameters
int: total_cap = 100;
int: min_diff_XY = 10;
int: cap_YZ = 70;

int: costX = 5;
int: costY = 3;
int: costZ = 4;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;
constraint X >= Y + min_diff_XY;
constraint Y + Z <= cap_YZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;