% Parameters (with values embedded)
int: meat_per_wrap = 5;
int: rice_per_wrap = 3;
int: time_per_wrap = 10;

int: meat_per_platter = 7;
int: rice_per_platter = 5;
int: time_per_platter = 8;

int: min_meat = 3000;
int: min_rice = 2500;

% Variables
var 0..10000: wraps;
var 0..10000: platters;
var 0..1000000: total_time;

% Constraints
constraint meat_per_wrap * wraps + meat_per_platter * platters >= min_meat;
constraint rice_per_wrap * wraps + rice_per_platter * platters >= min_rice;

% at least 3 times as many wraps as platters
constraint wraps >= 3 * platters;

% total time definition
constraint total_time = time_per_wrap * wraps + time_per_platter * platters;

% Objective
solve minimize total_time;