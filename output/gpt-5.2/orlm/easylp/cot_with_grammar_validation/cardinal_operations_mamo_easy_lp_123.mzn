% Parameters
int: total_hours_limit = 10;
int: min_learning = 20;

int: learn_x = 5;
int: learn_y = 6;

int: res_x = 2;
int: res_y = 3;

% Variables
var 0..total_hours_limit: x;
var 0..total_hours_limit: y;

var 0..(res_x*total_hours_limit + res_y*total_hours_limit): total_resource;

% Constraints
constraint x + y <= total_hours_limit;
constraint learn_x * x + learn_y * y >= min_learning;
constraint total_resource = res_x * x + res_y * y;

% Objective
solve minimize total_resource;