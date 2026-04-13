% Parameters
int: maxX = 30;
int: maxY = 20;
int: a1 = 5;
int: b1 = 3;
int: cap1 = 200;
int: a2 = 10;
int: b2 = 15;
int: req2 = 300;
int: diffMax = 50;
int: costX = 10000;
int: costY = 15000;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint a1 * X + b1 * Y <= cap1;
constraint a2 * X + b2 * Y >= req2;
constraint abs(X - Y) <= diffMax;

constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;