% Parameters
int: max_vehicles = 1000;

int: min_x = 300;
int: min_y = 200;
int: min_z = 150;

int: cost_x = 3;
int: cost_y = 2;
int: cost_z = 5;

% Variables
var 0..max_vehicles: x;
var 0..max_vehicles: y;
var 0..max_vehicles: z;

var 0..(max_vehicles * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= max_vehicles;

constraint x >= min_x;
constraint y >= min_y;
constraint z >= min_z;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;