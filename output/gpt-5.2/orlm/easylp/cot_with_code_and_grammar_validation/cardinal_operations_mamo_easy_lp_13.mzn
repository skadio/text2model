% Parameters
int: cost_solar = 4;
int: cost_wind  = 5;

int: a_solar = 3;
int: a_wind  = 2;
int: min_total_power = 10;

int: max_diff_power = 5;

% Variables
var 0..100: x_solar;
var 0..100: x_wind;

% Constraints
constraint a_solar * x_solar + a_wind * x_wind >= min_total_power;

constraint a_solar * x_solar - a_wind * x_wind <= max_diff_power;
constraint a_wind * x_wind - a_solar * x_solar <= max_diff_power;

% Objective
solve minimize cost_solar * x_solar + cost_wind * x_wind;