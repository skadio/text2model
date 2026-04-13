% Parameters
int: max_total = 24;
int: min_X = 4;
int: min_Y = 6;
int: min_Z = 5;

int: cost_X = 8;
int: cost_Y = 6;
int: cost_Z = 5;

% Variables
var min_X..max_total: X;
var min_Y..max_total: Y;
var min_Z..max_total: Z;

var 0..(max_total * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;