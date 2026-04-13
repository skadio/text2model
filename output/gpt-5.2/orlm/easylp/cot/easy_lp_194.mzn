% Parameters (with values embedded)
int: max_total = 1000;
int: min_2x_plus_y = 200;
int: max_x_plus_z = 300;

int: costX = 5;
int: costY = 4;
int: costZ = 3;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(costX*max_total + costY*max_total + costZ*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint 2*X + Y >= min_2x_plus_y;
constraint X + Z <= max_x_plus_z;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;