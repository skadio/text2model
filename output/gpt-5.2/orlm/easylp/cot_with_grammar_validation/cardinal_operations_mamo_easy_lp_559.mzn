% Parameters
int: B = 500;
int: min_combo = 400;
int: max_diff_YZ = 150;
int: min_diff_XZ = 100;

int: costX = 50;
int: costY = 30;
int: costZ = 80;

% Variables
var 0..B: X;
var 0..B: Y;
var 0..B: Z;

var 0..(costX*B + costY*B + costZ*B): total_cost;

% Constraints
constraint X + Y + Z <= B;
constraint 2 * X + 3 * Y >= min_combo;
constraint abs(Y - Z) <= max_diff_YZ;
constraint X - Z >= min_diff_XZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;