% Parameters
int: max_total = 50;
int: min_x = 10;
int: min_y = 5;
int: min_z = 8;

int: cost_x = 100;
int: cost_y = 80;
int: cost_z = 150;

% Variables
var min_x..max_total: X;
var min_y..max_total: Y;
var min_z..max_total: Z;

var 0..(max_total * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;