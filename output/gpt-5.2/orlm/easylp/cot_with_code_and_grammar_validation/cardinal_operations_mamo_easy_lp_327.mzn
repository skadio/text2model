% Parameters
int: max_total = 1000;
int: min_X = 400;
int: min_Y = 250;
int: min_Z = 350;

int: cost_X = 200000;
int: cost_Y = 300000;
int: cost_Z = 150000;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(max_total * max(cost_X, max(cost_Y, cost_Z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;