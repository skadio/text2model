% Parameters
int: BUDGET = 1000;
int: cX = 10;
int: cY = 15;
int: cZ = 20;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;
var 0..(cX*BUDGET + cY*BUDGET + cZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= 2 * Y + 200;
constraint Z >= Y + 100;

constraint total_cost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_cost;