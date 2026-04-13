% Parameters
int: total_max = 200;
int: min_X = 50;
int: min_Y = 30;
int: min_Z = 20;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

% Variables
var min_X..total_max: X;
var min_Y..total_max: Y;
var min_Z..total_max: Z;

var 0..(total_max * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= total_max;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;