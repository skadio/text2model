% Parameters (with values embedded)
int: max_total_packages = 50;
int: min_total_packages = 10;
int: max_excess_x_over_2y = 20;

int: res_per_x = 100;
int: res_per_y = 150;

% Variables
var 0..max_total_packages: X;
var 0..max_total_packages: Y;
var 0..(res_per_x*max_total_packages + res_per_y*max_total_packages): total_resources;

% Constraints
constraint X + Y <= max_total_packages;
constraint X + Y >= min_total_packages;
constraint X - 2*Y <= max_excess_x_over_2y;

constraint total_resources = res_per_x * X + res_per_y * Y;

% Objective
solve minimize total_resources;