% Parameters
int: max_total = 50;
int: min_X = 10;
int: min_Y = 5;
int: min_Z = 8;

int: cost_X = 100;
int: cost_Y = 80;
int: cost_Z = 150;

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