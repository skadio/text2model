% Parameters
int: max_total = 1000;
int: min_weighted = 500;
int: max_diff = 400;
int: min_y_minus_z = 100;

int: costX = 5;
int: costY = 7;
int: costZ = 3;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(costX*max_total + costY*max_total + costZ*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint 2*X + 3*Y >= min_weighted;
constraint X + Z - Y <= max_diff;
constraint Y - Z >= min_y_minus_z;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;