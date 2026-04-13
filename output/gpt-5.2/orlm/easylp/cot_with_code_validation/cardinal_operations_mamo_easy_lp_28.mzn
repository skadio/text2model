% Parameters
int: min_total_vehicles = 10;
int: cap_limit = 25;
int: cap_x = 2;
int: cap_y = 3;
int: cost_x = 5;
int: cost_y = 7;

% Variables
var 0..cap_limit: x;
var 0..cap_limit: y;
var 0..(cost_x*cap_limit + cost_y*cap_limit): total_cost;

% Constraints
constraint x + y >= min_total_vehicles;
constraint cap_x * x + cap_y * y <= cap_limit;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;