% Parameters (with values embedded)
int: hours_part_time = 15;
int: pay_part_time = 450;

int: hours_full_time = 40;
int: pay_full_time = 1280;

int: required_hours = 1000;
int: budget = 31500;

% Upper bounds derived from constraints (safe finite bounds)
int: max_part_time = budget div pay_part_time;   % cannot exceed budget if all part-time
int: max_full_time = budget div pay_full_time;   % cannot exceed budget if all full-time

% Variables
var 0..max_part_time: n_part_time;
var 0..max_full_time: n_full_time;

% Constraints
constraint hours_part_time * n_part_time + hours_full_time * n_full_time >= required_hours;
constraint pay_part_time * n_part_time + pay_full_time * n_full_time <= budget;

% Objective
solve minimize (n_part_time + n_full_time);