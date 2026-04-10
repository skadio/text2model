% Parameters
int: cost_solar = 10;
int: cost_wind = 15;
int: cost_nuclear = 20;

int: min_total_production = 10000;
int: max_diff_solar_wind = 5000;
int: min_nuclear_over_wind = 2000;

% Variables
var 0..min_total_production: solar;
var 0..min_total_production: wind;
var 0..min_total_production: nuclear;

var 0..(cost_solar*min_total_production + cost_wind*min_total_production + cost_nuclear*min_total_production): total_cost;

% Constraints
constraint solar + wind + nuclear >= min_total_production;

constraint abs(solar - wind) <= max_diff_solar_wind;

constraint nuclear >= wind + min_nuclear_over_wind;

constraint total_cost = cost_solar*solar + cost_wind*wind + cost_nuclear*nuclear;

% Objective
solve minimize total_cost;