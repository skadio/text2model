% Parameters (with values embedded)
int: max_total = 150;
int: min_diff_XY = 10;      % X >= Y + 10
int: max_diff_YZ = 20;      % Y <= Z + 20

int: costX = 100;
int: costY = 50;
int: costZ = 30;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(costX*max_total + costY*max_total + costZ*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint X >= Y + min_diff_XY;
constraint Y <= Z + max_diff_YZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;