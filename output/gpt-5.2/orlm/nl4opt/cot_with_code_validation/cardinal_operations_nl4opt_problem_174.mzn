% Parameters
int: time_elec = 3;
int: time_reg = 2;
int: total_time = 15000;
int: min_reg = 50;

% Variables
var 0..(total_time div time_elec): e; % number of electronic thermometer readings
var min_reg..(total_time div time_reg): r; % number of regular thermometer readings

% Constraints
constraint time_elec * e + time_reg * r <= total_time;
constraint e >= 2 * r;

% Objective
solve maximize e + r;