% Parameters
int: budget = 5000;
int: cX = 20;
int: cY = 15;
int: cZ = 30;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;
var 0..(cX*budget + cY*budget + cZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint X >= 2000 - 3 * Y;
constraint Z >= 1000 + Y;

constraint total_cost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_cost;