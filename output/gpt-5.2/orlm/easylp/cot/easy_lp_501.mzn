% Parameters (with values embedded)
int: cost_residential = 1000;
int: cost_commercial  = 500;
int: max_total_units  = 50;
int: min_x = 10;
int: min_y = 20;
int: max_diff = 10;

% Variables
var min_x..max_total_units: x;  % residential units
var min_y..max_total_units: y;  % commercial units
var 0..(cost_residential*max_total_units + cost_commercial*max_total_units): total_cost;

% Constraints
constraint x + y <= max_total_units;
constraint x - y <= max_diff;

constraint total_cost = cost_residential * x + cost_commercial * y;

% Objective
solve minimize total_cost;