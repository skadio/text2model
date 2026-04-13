% Parameters
int: budget = 100;
int: req = 50;
int: diff_max = 20;

int: costX = 5000;
int: costY = 4000;
int: costZ = 3000;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(budget * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint 2*X + 3*Y >= req;

constraint abs(X - Z) <= diff_max;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;