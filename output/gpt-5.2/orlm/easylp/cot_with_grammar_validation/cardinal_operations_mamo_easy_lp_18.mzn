% Parameters
int: cost_solar = 50;
int: cost_wind  = 60;

int: min_total_capacity = 1000;
int: max_3solar_minus_wind = 500;

% Variables
var 0..min_total_capacity: solar;
var 0..min_total_capacity: wind;

var 0..(cost_solar * min_total_capacity + cost_wind * min_total_capacity): total_cost;

% Constraints
constraint solar + wind >= min_total_capacity;
constraint 3 * solar - wind <= max_3solar_minus_wind;

constraint total_cost = cost_solar * solar + cost_wind * wind;

% Objective
solve minimize total_cost;