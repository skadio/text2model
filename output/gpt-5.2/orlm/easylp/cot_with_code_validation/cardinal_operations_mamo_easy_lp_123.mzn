% Parameters
int: max_hours = 10;
int: min_learning = 20;
int: learning_x = 5;
int: learning_y = 6;
int: resource_x = 2;
int: resource_y = 3;

% Variables
var 0..max_hours: x;
var 0..max_hours: y;
var 0..(resource_x*max_hours + resource_y*max_hours): total_resource;

% Constraints
constraint x + y <= max_hours;
constraint learning_x * x + learning_y * y >= min_learning;
constraint total_resource = resource_x * x + resource_y * y;

% Objective
solve minimize total_resource;