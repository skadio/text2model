% Parameters
int: max_hours = 10;
int: min_effort = 20;
int: effort_x = 5;
int: effort_y = 6;
int: res_x = 2;
int: res_y = 3;

% Variables
var 0..max_hours: x;
var 0..max_hours: y;
var 0..(res_x*max_hours + res_y*max_hours): total_resource;

% Constraints
constraint x + y <= max_hours;
constraint effort_x * x + effort_y * y >= min_effort;
constraint total_resource = res_x * x + res_y * y;

% Objective
solve minimize total_resource;