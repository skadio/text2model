% Parameters
int: hours_part_time = 15;
int: pay_part_time = 450;
int: hours_full_time = 40;
int: pay_full_time = 1280;

int: required_hours = 1000;
int: budget = 31500;

% Variables
var 0..(required_hours div hours_part_time + 1): n_part;
var 0..(required_hours div hours_full_time + 1): n_full;

var 0..(required_hours div min(hours_part_time, hours_full_time) + 1): total_staff = n_part + n_full;

% Constraints
constraint hours_part_time * n_part + hours_full_time * n_full >= required_hours;
constraint pay_part_time * n_part + pay_full_time * n_full <= budget;

% Objective
solve minimize total_staff;