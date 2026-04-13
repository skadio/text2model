% Parameters
int: budget = 100;
int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;
var 0..(budget * max([costX, costY, costZ])): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint X >= 2 * Y;
constraint Z >= X + 10;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;