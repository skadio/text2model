% Parameters
int: BUDGET = 1000;
int: min_excess_X_over_2Y = 200;
int: min_excess_Z_over_Y = 100;

int: costX = 2;
int: costY = 3;
int: costZ = 1;

% Variables
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

var 0..(costX*BUDGET + costY*BUDGET + costZ*BUDGET): total_cost;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint X >= 2*Y + min_excess_X_over_2Y;
constraint Z >= Y + min_excess_Z_over_Y;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;