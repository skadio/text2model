% Parameters
int: BUDGET = 5000;
int: minX_over_2Y = 1000;
int: minZ_over_Y = 1500;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint X - 2*Y >= minX_over_2Y;
constraint Z - Y >= minZ_over_Y;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;