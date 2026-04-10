% Parameters
int: total_employees = 1000;
int: min_diff_XY = 200;
int: min_diff_YZ = 100;

int: cost_X = 50;
int: cost_Y = 60;
int: cost_Z = 70;

int: max_X = 500;
int: max_Y = 400;
int: max_Z = 300;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;

var 0..(total_employees * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint X + Y + Z <= total_employees;

constraint X >= Y + min_diff_XY;
constraint Y >= Z + min_diff_YZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;