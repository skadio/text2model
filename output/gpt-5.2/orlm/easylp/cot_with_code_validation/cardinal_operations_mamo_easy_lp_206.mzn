% Parameters
int: total_cap = 150;
int: min_diff_XY = 10;          % X >= Y + 10
int: max_diff_YZ = 20;          % Y <= Z + 20
int: costX = 100;
int: costY = 50;
int: costZ = 30;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;
var 0..(costX*total_cap + costY*total_cap + costZ*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;
constraint X >= Y + min_diff_XY;
constraint Y <= Z + max_diff_YZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;