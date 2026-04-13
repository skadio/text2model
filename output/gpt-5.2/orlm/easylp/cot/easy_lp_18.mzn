% Parameters (with values embedded)
int: cost_solar = 50;
int: cost_wind  = 60;

int: min_total_capacity = 1000;
int: max_three_solar_minus_wind = 500;

% Variables
var 0..100000: solar; % capacity units (integer)
var 0..100000: wind;  % capacity units (integer)

var 0..100000000: total_cost;

% Constraints
constraint solar + wind >= min_total_capacity;
constraint 3 * solar - wind <= max_three_solar_minus_wind;

constraint total_cost = cost_solar * solar + cost_wind * wind;

% Objective
solve minimize total_cost;