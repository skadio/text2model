% Parameters
int: min_effort = 100;
int: max_effort2 = 200;
int: max_diff_xz = 50;

int: costX = 5;
int: costY = 6;
int: costZ = 4;

% Variables
var 0..200: X;
var 0..100: Y;
var 0..250: Z;

var 0..(costX*200 + costY*100 + costZ*250): total_support;

% Constraints
constraint X + 2*Y + Z >= min_effort;
constraint 2*X + Y <= max_effort2;

constraint X - Z <= max_diff_xz;
constraint Z - X <= max_diff_xz;

constraint total_support = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_support;