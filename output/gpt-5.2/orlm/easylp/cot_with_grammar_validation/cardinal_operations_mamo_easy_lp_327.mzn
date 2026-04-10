% Parameters
int: max_total = 1000;
int: min_X = 400;
int: min_Y = 250;
int: min_Z = 350;

int: cost_X = 200000; % dollars per single-family home
int: cost_Y = 300000; % dollars per multi-family home
int: cost_Z = 150000; % dollars per commercial building

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