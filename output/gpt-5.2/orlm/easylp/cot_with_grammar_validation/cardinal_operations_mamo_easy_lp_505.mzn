% Parameters
int: total_budget = 5000;
int: min_diff_XY = 50;
int: max_diff_ZX = 1000;
int: max_diff_ZY = 200;

int: cost_X = 500;
int: cost_Y = 300;
int: cost_Z = 1000;

int: max_X = 2500;
int: max_Y = 1500;
int: max_Z = 4000;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;

var 0..(cost_X*max_X + cost_Y*max_Y + cost_Z*max_Z): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint X >= Y + min_diff_XY;

constraint abs(Z - X) <= max_diff_ZX;
constraint abs(Z - Y) <= max_diff_ZY;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;