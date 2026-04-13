% Parameters
int: req1 = 100;
int: cap2 = 200;
int: diff_cap = 50;

int: costX = 5;
int: costY = 6;
int: costZ = 4;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

var 0..100000: total_support;

% Constraints
constraint X + 2*Y + Z >= req1;
constraint 2*X + Y <= cap2;
constraint X - Z <= diff_cap;

constraint total_support = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_support;