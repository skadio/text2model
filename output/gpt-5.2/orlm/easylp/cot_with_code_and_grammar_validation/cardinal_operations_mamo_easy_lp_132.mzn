% Parameters
int: costX = 4;
int: costY = 5;
int: cap1 = 100;
int: rhs2 = 50;

% Variables
var 0..cap1: x;
var 0..cap1: y;

% Constraints
constraint x + 2*y <= cap1;
constraint 3*x - y >= rhs2;

% Objective
solve minimize costX * x + costY * y;