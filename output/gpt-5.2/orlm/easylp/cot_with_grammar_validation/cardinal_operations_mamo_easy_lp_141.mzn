% Parameters
int: min_units = 10;
int: firepower_limit = 50;

int: firepower_x = 5;
int: firepower_y = 3;

int: cost_x = 1000;
int: cost_y = 2000;

% Variables
var 0..min_units: x;
var 0..min_units: y;
var 0..(cost_x*min_units + cost_y*min_units): total_cost;

% Constraints
constraint x + y >= min_units;
constraint firepower_x * x + firepower_y * y <= firepower_limit;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;