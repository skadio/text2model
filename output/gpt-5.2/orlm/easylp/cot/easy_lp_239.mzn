% Parameters (with values embedded)
int: budget = 1000;
int: min_strength = 400;
int: max_diff_ZY = 300;

int: costX = 300;
int: costY = 500;
int: costZ = 200;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint 3 * X + 2 * Y >= min_strength;
constraint abs(Z - Y) <= max_diff_ZY;
constraint X > 2 * Z;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;