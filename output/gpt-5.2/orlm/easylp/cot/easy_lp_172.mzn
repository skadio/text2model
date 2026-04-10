% Parameters (with values embedded)
int: budget = 5000;

int: min_diff_XY = 1000;
int: max_abs_diff_ZY = 1500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint X >= Y + min_diff_XY;
constraint abs(Z - Y) <= max_abs_diff_ZY;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;