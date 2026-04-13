% Parameters
int: costX = 4;
int: costY = 5;
int: limit1 = 100;      % x + 2y <= 100
int: rhs2 = 50;         % 3x - y >= 50

% Variables
var 0..limit1: x;       % resources for Project X
var 0..limit1: y;       % resources for Project Y

% Constraints
constraint x + 2*y <= limit1;
constraint 3*x - y >= rhs2;

% Objective
solve minimize costX*x + costY*y;