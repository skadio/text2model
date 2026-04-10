% Parameters
int: meat_per_wrap = 5;
int: rice_per_wrap = 3;
int: time_per_wrap = 10;

int: meat_per_platter = 7;
int: rice_per_platter = 5;
int: time_per_platter = 8;

int: min_meat = 3000;
int: min_rice = 2500;

int: wrap_to_platter_ratio = 3;

% Variables
var 0..10000: wraps;
var 0..10000: platters;

% Constraints
constraint meat_per_wrap * wraps + meat_per_platter * platters >= min_meat;
constraint rice_per_wrap * wraps + rice_per_platter * platters >= min_rice;

constraint wraps >= wrap_to_platter_ratio * platters;

% Objective
solve minimize time_per_wrap * wraps + time_per_platter * platters;