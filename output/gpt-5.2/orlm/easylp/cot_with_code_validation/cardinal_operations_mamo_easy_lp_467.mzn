% Parameters
int: max_total_hires = 10;
int: min_x = 3;
int: min_y = 2;
int: max_x = 7;
int: max_y = 8;
int: cost_x = 50000;
int: cost_y = 40000;

% Variables
var min_x..max_x: x_hires;
var min_y..max_y: y_hires;
var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint x_hires + y_hires <= max_total_hires;
constraint total_cost = cost_x * x_hires + cost_y * y_hires;

% Objective
solve minimize total_cost;