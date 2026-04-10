% Parameters
int: cost_solar = 4;
int: cost_wind  = 5;

int: a_solar = 3;
int: a_wind  = 2;
int: min_total_power = 10;

int: max_diff_power = 5;

% Variables
var 0..1000: solar_units;
var 0..1000: wind_units;

var int: total_cost;

% Constraints
constraint a_solar * solar_units + a_wind * wind_units >= min_total_power;

constraint abs(solar_units - wind_units) <= max_diff_power;

constraint total_cost = cost_solar * solar_units + cost_wind * wind_units;

% Objective
solve minimize total_cost;