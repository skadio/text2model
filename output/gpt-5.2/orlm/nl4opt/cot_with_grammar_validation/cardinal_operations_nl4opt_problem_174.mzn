% Parameters
int: time_e = 3;
int: time_r = 2;
int: total_time = 15000;
int: min_regular = 50;

% Variables
var 0..(total_time div min(time_e, time_r)): e; % number checked with electronic
var 0..(total_time div min(time_e, time_r)): r; % number checked with regular
var 0..(total_time div min(time_e, time_r)): total_patients;

% Constraints
constraint time_e * e + time_r * r <= total_time;
constraint e >= 2 * r;
constraint r >= min_regular;
constraint total_patients = e + r;

% Objective
solve maximize total_patients;