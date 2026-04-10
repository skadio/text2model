% Parameters
int: total_cap = 1000;
int: min_diff_XY = 200;
int: min_diff_ZY = 50;

int: cost_X = 4;
int: cost_Y = 5;
int: cost_Z = 6;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;
var 0..total_cap: Z;

var 0..(cost_X*total_cap + cost_Y*total_cap + cost_Z*total_cap): total_cost;

% Constraints
constraint X + Y + Z <= total_cap;
constraint X >= Y + min_diff_XY;
constraint Z >= Y + min_diff_ZY;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;