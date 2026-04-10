% Parameters
int: cost_residential = 1000;
int: cost_commercial = 500;
int: max_total_units = 50;
int: min_residential_units = 10;
int: min_commercial_units = 20;
int: max_res_minus_com = 10;

% Variables
var min_residential_units..max_total_units: x; % residential units
var min_commercial_units..max_total_units: y;  % commercial units
var 0..(cost_residential * max_total_units + cost_commercial * max_total_units): total_cost;

% Constraints
constraint x + y <= max_total_units;
constraint x - y <= max_res_minus_com;
constraint total_cost = cost_residential * x + cost_commercial * y;

% Objective
solve minimize total_cost;