% Parameters (with values embedded)
int: max_total_vehicles = 1000;
int: min_x = 400;
int: min_y = 300;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var 0..max_total_vehicles: x; % vehicles on route X
var 0..max_total_vehicles: y; % vehicles on route Y
var 0..(cost_x * max_total_vehicles + cost_y * max_total_vehicles): total_cost;

% Constraints
constraint x + y <= max_total_vehicles;
constraint x >= min_x;
constraint y >= min_y;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;