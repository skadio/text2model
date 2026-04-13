% Parameters
int: total_max = 150;
int: min_diff_XY = 10;
int: max_diff_YZ = 20;

int: costX = 100;
int: costY = 50;
int: costZ = 30;

% Variables
var 0..total_max: X;
var 0..total_max: Y;
var 0..total_max: Z;

var 0..(costX*total_max + costY*total_max + costZ*total_max): total_cost;

% Constraints
constraint X + Y + Z <= total_max;

constraint X >= Y + min_diff_XY;
constraint Y <= Z + max_diff_YZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;