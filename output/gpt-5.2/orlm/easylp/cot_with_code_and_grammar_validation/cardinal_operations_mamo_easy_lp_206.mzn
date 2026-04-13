% Parameters
int: max_total = 150;
int: x_min_more_than_y = 10;
int: y_max_more_than_z = 20;

int: cost_x = 100;
int: cost_y = 50;
int: cost_z = 30;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(max_total * max(cost_x, max(cost_y, cost_z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total;

constraint X >= Y + x_min_more_than_y;
constraint Y <= Z + y_max_more_than_z;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;