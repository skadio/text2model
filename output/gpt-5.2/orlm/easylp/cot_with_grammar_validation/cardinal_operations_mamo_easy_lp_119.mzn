% Parameters
int: max_trips = 50;
int: min_weighted_trips = 30;
int: weight_x = 2;
int: weight_y = 3;
int: cost_x = 100;
int: cost_y = 200;

% Variables
var 0..max_trips: x;
var 0..max_trips: y;
var 0..(cost_x * max_trips + cost_y * max_trips): total_cost;

% Constraints
constraint x + y <= max_trips;
constraint weight_x * x + weight_y * y >= min_weighted_trips;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;