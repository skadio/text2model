% Parameters
int: costX = 20;
int: costY = 30;

int: totalLimit = 1000;
int: diffMin = 200;
int: mixLimit = 1500;

int: maxX = 800;
int: maxY = 600;

% Variables
var 0..maxX: x;
var 0..maxY: y;

% Constraints
constraint x + y <= totalLimit;
constraint abs(x - y) >= diffMin;
constraint 2 * x + y <= mixLimit;

% Objective
solve minimize costX * x + costY * y;