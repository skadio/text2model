% Parameters
int: BUDGET = 5000;
int: min_X_minus_2Y = 1000;
int: min_Z_minus_Y = 1500;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): TotalCost;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint X - 2*Y >= min_X_minus_2Y;
constraint Z - Y >= min_Z_minus_Y;

constraint TotalCost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize TotalCost;