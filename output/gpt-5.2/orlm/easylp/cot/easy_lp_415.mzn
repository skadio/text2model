% Parameters (with values embedded)
int: min_total_units = 300;
int: max_total_units = 1000;
int: min_diff_tv_over_radio = 100;

int: cost_tv = 200;
int: cost_radio = 500;

% Variables
var 0..max_total_units: tv_units;
var 0..max_total_units: radio_units;
var 0..(cost_tv*max_total_units + cost_radio*max_total_units): total_cost;

% Constraints
constraint tv_units + radio_units >= min_total_units;
constraint tv_units + radio_units <= max_total_units;
constraint tv_units - radio_units >= min_diff_tv_over_radio;

constraint total_cost = cost_tv * tv_units + cost_radio * radio_units;

% Objective
solve minimize total_cost;