% Parameters
int: min_total_units = 300;
int: max_total_units = 1000;
int: min_tv_minus_radio = 100;
int: cost_tv = 200;
int: cost_radio = 500;

% Variables
var 0..max_total_units: tv;
var 0..max_total_units: radio;
var 0..(cost_tv*max_total_units + cost_radio*max_total_units): total_cost;

% Constraints
constraint tv + radio >= min_total_units;
constraint tv + radio <= max_total_units;

constraint tv - radio >= min_tv_minus_radio;

constraint total_cost = cost_tv * tv + cost_radio * radio;

% Objective
solve minimize total_cost;