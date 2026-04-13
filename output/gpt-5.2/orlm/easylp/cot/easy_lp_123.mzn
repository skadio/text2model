% Parameters (with values embedded)
int: max_hours = 10;
int: min_learning = 20;
int: learn_x = 5;
int: learn_y = 6;
int: res_x = 2;
int: res_y = 3;

% Variables
var 0..max_hours: x;                % hours for activity X (integer)
var 0..max_hours: y;                % hours for activity Y (integer)
var 0..(res_x*max_hours + res_y*max_hours): total_resource;

% Constraints
constraint x + y <= max_hours;
constraint learn_x * x + learn_y * y >= min_learning;
constraint total_resource = res_x * x + res_y * y;

% Objective
solve minimize total_resource;