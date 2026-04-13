% Parameters
int: capacity = 1000;
int: perf_min = 500;
int: balance_max = 400;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

var 0..(capacity * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= capacity;

constraint 5*X + 3*Y - Z >= perf_min;

constraint X + Z - Y <= balance_max;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;