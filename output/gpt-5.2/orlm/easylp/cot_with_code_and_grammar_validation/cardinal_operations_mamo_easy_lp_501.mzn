% Parameters
int: cost_res = 1000;
int: cost_com = 500;
int: max_total_units = 50;

int: min_res = 10;
int: min_com = 20;
int: max_res_minus_com = 10;

% Variables
var min_res..max_total_units: x; % residential units
var min_com..max_total_units: y; % commercial units
var 0..(cost_res * max_total_units + cost_com * max_total_units): total_cost;

% Constraints
constraint x + y <= max_total_units;
constraint x - y <= max_res_minus_com;

constraint total_cost = cost_res * x + cost_com * y;

% Objective
solve minimize total_cost;