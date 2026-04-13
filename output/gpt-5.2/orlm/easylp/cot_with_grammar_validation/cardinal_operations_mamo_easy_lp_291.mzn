% Parameters
int: max_total = 1000;

int: min_X = 200;
int: min_Y = 150;
int: min_Z = 120;

int: cost_X = 10;
int: cost_Y = 20;
int: cost_Z = 30;

% Variables
var min_X..max_total: X;
var min_Y..max_total: Y;
var min_Z..max_total: Z;

var 0..(cost_X*max_total + cost_Y*max_total + cost_Z*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;