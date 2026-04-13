% Parameters
int: costX = 50;
int: costY = 10;

int: a1X = 2;
int: a1Y = 1;
int: cap1 = 200;

int: a2X = 4;
int: a2Y = 1;
int: min2 = 50;

% Variables
var 0..cap1: x;
var 0..cap1: y;
var 0..(costX*cap1 + costY*cap1): total_cost;

% Constraints
constraint a1X * x + a1Y * y <= cap1;
constraint a2X * x + a2Y * y >= min2;
constraint total_cost = costX * x + costY * y;

% Objective
solve minimize total_cost;