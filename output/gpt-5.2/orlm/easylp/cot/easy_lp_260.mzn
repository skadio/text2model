% Parameters (with values embedded)
int: total_budget = 1000;
int: min_diff_XY = 200;
int: min_diff_ZY = 50;

int: costX = 4;
int: costY = 5;
int: costZ = 6;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(costX*total_budget + costY*total_budget + costZ*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;
constraint X >= Y + min_diff_XY;
constraint Z >= Y + min_diff_ZY;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;