% Parameters
int: req_min = 100;
int: cap_max = 200;
int: diff_max = 50;

int: costX = 5;
int: costY = 6;
int: costZ = 4;

% Variables
var 0..cap_max: X;
var 0..cap_max: Y;
var 0..cap_max: Z;

var 0..(costX*cap_max + costY*cap_max + costZ*cap_max): total_support;

% Constraints
constraint X + 2*Y + Z >= req_min;
constraint 2*X + Y <= cap_max;
constraint X - Z <= diff_max;
constraint Z - X <= diff_max;

constraint total_support = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_support;