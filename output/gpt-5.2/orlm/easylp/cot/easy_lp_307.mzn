% Parameters (with values embedded)
int: budget = 1000;
int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;
var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint X >= 2 * Y + 200;
constraint Z >= Y + 100;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;