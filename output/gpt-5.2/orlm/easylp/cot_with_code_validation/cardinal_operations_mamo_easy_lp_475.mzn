% Parameters
int: max_total_packages = 50;
int: min_total_packages = 10;
int: x_excess_over_2y_max = 20;
int: resource_x = 100;
int: resource_y = 150;

% Variables
var 0..max_total_packages: x;
var 0..max_total_packages: y;
var 0..(resource_x*max_total_packages + resource_y*max_total_packages): total_resources;

% Constraints
constraint x + y <= max_total_packages;
constraint x + y >= min_total_packages;
constraint x - 2*y <= x_excess_over_2y_max;

constraint total_resources = resource_x * x + resource_y * y;

% Objective
solve minimize total_resources;