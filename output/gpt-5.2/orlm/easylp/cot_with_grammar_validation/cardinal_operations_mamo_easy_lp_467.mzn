% Parameters
int: max_total_hires = 10;
int: min_x_hires = 3;
int: min_y_hires = 2;
int: max_x_hires = 7;
int: max_y_hires = 8;
int: cost_x = 50000;
int: cost_y = 40000;

% Variables
var 0..max_x_hires: x_hires;
var 0..max_y_hires: y_hires;
var 0..(max_x_hires*cost_x + max_y_hires*cost_y): total_cost;

% Constraints
constraint x_hires >= min_x_hires;
constraint y_hires >= min_y_hires;
constraint x_hires + y_hires <= max_total_hires;

constraint total_cost = cost_x * x_hires + cost_y * y_hires;

% Objective
solve minimize total_cost;