% Parameters
int: budget = 1000;
int: min_diff_XY = 200;
int: min_diff_ZY = 50;

int: costX = 4;
int: costY = 5;
int: costZ = 6;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint X >= Y + min_diff_XY;
constraint Z >= Y + min_diff_ZY;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;