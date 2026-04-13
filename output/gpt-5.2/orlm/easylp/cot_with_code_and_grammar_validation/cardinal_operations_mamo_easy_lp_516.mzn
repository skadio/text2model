% Parameters
int: capacity = 2000;
int: min_diff_X_vs_2Y = 1000;
int: min_diff_Z_vs_Y = 500;

int: costX = 3;
int: costY = 2;
int: costZ = 1;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..capacity: Z;

% Constraints
constraint X + Y + Z <= capacity;

% |X - 2Y| >= 1000  <=>  X - 2Y >= 1000 OR 2Y - X >= 1000
constraint (X - 2*Y >= min_diff_X_vs_2Y) \/ (2*Y - X >= min_diff_X_vs_2Y);

% |Z - Y| >= 500  <=>  Z - Y >= 500 OR Y - Z >= 500
constraint (Z - Y >= min_diff_Z_vs_Y) \/ (Y - Z >= min_diff_Z_vs_Y);

% Objective
var 0..(costX*capacity + costY*capacity + costZ*capacity): total_cost;
constraint total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;