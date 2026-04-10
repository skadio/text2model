% Parameters
int: max_total = 100;
int: req1 = 50;              % 2*X + 1*Y >= 50
int: req2 = 40;              % 1*X + 1*Z >= 40
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;
var 0..(max_total * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint 2*X + Y >= req1;
constraint X + Z >= req2;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;