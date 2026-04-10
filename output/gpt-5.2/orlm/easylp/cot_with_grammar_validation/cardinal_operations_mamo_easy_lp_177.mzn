% Parameters
int: cost_solar = 10;
int: cost_wind = 15;
int: cost_nuclear = 20;

int: total_min = 10000;
int: diff_sw_max = 5000;
int: nuclear_minus_wind_min = 2000;

% Variables
var 0..total_min: solar;
var 0..total_min: wind;
var 0..total_min: nuclear;

var 0..(cost_solar*total_min + cost_wind*total_min + cost_nuclear*total_min): total_cost;

% Constraints
constraint solar + wind + nuclear >= total_min;

constraint abs(solar - wind) <= diff_sw_max;

constraint nuclear >= wind + nuclear_minus_wind_min;

constraint total_cost = cost_solar * solar + cost_wind * wind + cost_nuclear * nuclear;

% Objective
solve minimize total_cost;