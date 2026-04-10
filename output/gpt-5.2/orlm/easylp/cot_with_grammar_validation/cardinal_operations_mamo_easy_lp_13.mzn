% Parameters
int: cost_solar = 4;
int: cost_wind  = 5;

int: a_solar = 3;
int: a_wind  = 2;
int: min_total_power = 10;

int: max_power_diff = 5;

% Variables
var 0..100: solar_units;
var 0..100: wind_units;

var 0..(cost_solar*100 + cost_wind*100): total_cost;

% Constraints
constraint a_solar * solar_units + a_wind * wind_units >= min_total_power;

constraint abs(solar_units - wind_units) <= max_power_diff;

constraint total_cost = cost_solar * solar_units + cost_wind * wind_units;

% Objective
solve minimize total_cost;