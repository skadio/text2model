% Parameters
int: max_total = 1000;
int: min_x_minus_y = 10;
int: max_z_minus_y = 20;

int: cost_x = 5;
int: cost_y = 2;
int: cost_z = 3;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint X - Y >= min_x_minus_y;
constraint Z - Y <= max_z_minus_y;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;