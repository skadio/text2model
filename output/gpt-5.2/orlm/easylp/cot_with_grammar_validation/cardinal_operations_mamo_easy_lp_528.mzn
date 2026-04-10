% Parameters
int: max_total = 1000;
int: min_x_minus_y = 50;
int: max_abs_z_minus_x = 200;
int: min_y_plus_z = 400;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 4;

% Variables
var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

var 0..(cost_x*max_total + cost_y*max_total + cost_z*max_total): total_cost;

% Constraints
constraint X + Y + Z <= max_total;
constraint X >= Y + min_x_minus_y;
constraint abs(Z - X) <= max_abs_z_minus_x;
constraint Y + Z >= min_y_plus_z;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;