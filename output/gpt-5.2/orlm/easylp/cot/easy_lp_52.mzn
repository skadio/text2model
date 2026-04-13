% Parameters (with values embedded)
int: cost_X = 2;
int: cost_Y = 3;
int: max_total_units = 1000;
int: min_X = 200;
int: min_Y = 300;

% Variables
var min_X..max_total_units: X;
var min_Y..max_total_units: Y;
var 0..(cost_X*max_total_units + cost_Y*max_total_units): total_cost;

% Constraints
constraint X + Y <= max_total_units;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;