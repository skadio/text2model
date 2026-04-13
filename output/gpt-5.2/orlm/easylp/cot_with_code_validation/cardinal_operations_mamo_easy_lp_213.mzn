% Parameters
int: total_units = 100;
int: min_x = 10;
int: min_y = 20;
int: min_z = 15;
int: cost_x = 30;
int: cost_y = 20;
int: cost_z = 50;

% Variables
var min_x..total_units: X;
var min_y..total_units: Y;
var min_z..total_units: Z;
var 0..(cost_x*total_units + cost_y*total_units + cost_z*total_units): total_cost;

% Constraints
constraint X + Y + Z <= total_units;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;