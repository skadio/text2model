% Parameters
int: max_total = 50;
int: min_total = 10;
int: x_over_2y_plus = 20;

int: res_x = 100;
int: res_y = 150;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(max_total * max(res_x, res_y)): total_res;

% Constraints
constraint x + y <= max_total;
constraint x + y >= min_total;
constraint x - 2 * y <= x_over_2y_plus;

constraint total_res = res_x * x + res_y * y;

% Objective
solve minimize total_res;