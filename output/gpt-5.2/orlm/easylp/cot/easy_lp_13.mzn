% Parameters (with values embedded)
int: cost_solar = 4;
int: cost_wind  = 5;

int: req_solar_coeff = 3;
int: req_wind_coeff  = 2;
int: req_min_power   = 10;

int: diff_limit = 5;

% Variables
var 0..100: solar_units;
var 0..100: wind_units;

% Constraints
constraint req_solar_coeff * solar_units + req_wind_coeff * wind_units >= req_min_power;
constraint abs(solar_units - wind_units) <= diff_limit;

% Objective
var int: total_cost = cost_solar * solar_units + cost_wind * wind_units;
solve minimize total_cost;