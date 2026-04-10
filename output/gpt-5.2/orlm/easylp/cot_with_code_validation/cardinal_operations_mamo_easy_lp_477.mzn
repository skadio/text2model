% Parameters
int: total_resource_cap = 200;
int: perf_x_coeff = 3;
int: perf_y_coeff = 2;
int: min_performance = 400;
int: min_diff_xy = 50;

int: cost_x = 500;
int: cost_y = 300;

% Variables
var 0..total_resource_cap: X;
var 0..total_resource_cap: Y;
var 0..(cost_x*total_resource_cap + cost_y*total_resource_cap): total_cost;

% Constraints
constraint X + Y <= total_resource_cap;
constraint perf_x_coeff * X + perf_y_coeff * Y >= min_performance;
constraint X - Y >= min_diff_xy;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;