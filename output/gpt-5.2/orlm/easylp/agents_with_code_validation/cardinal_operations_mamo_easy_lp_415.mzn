% Parameters
% Minimum and maximum total investment units (TV + Radio)
int: min_total_units = 300;
int: max_total_units = 1000;

% Minimum required difference: TV must be at least (Radio + min_tv_over_radio)
int: min_tv_over_radio = 100;

% Cost per unit investment (whole ad slots)
int: cost_tv = 200;
int: cost_radio = 500;

% Derived upper bound for individual channel investments
int: max_units_per_channel = max_total_units;

% Variables
var 0..max_units_per_channel: tv_units;        % units invested in TV ads (integer)
var 0..max_units_per_channel: radio_units;     % units invested in Radio ads (integer)
var 0..(max_total_units * max(cost_tv, cost_radio)): total_cost; % total cost in dollars (integer)

% Constraints
% Total investment units must be within required bounds
constraint
  min_total_units <= tv_units + radio_units /\
  tv_units + radio_units <= max_total_units;

% TV investment must exceed Radio investment by at least the required margin
constraint
  tv_units >= radio_units + min_tv_over_radio;

% Define total cost from per-unit costs (all values are integers)
constraint
  total_cost = cost_tv * tv_units + cost_radio * radio_units;

% Objective
solve minimize total_cost;