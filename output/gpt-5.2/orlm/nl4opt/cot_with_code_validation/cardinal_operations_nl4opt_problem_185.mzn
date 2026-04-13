% Parameters
int: meat_per_wrap = 5;
int: rice_per_wrap = 3;
int: time_per_wrap = 10;

int: meat_per_platter = 7;
int: rice_per_platter = 5;
int: time_per_platter = 8;

int: min_meat = 3000;
int: min_rice = 2500;

int: wrap_ratio = 3; % wraps >= 3 * platters

% Variables
var 0..max(min_meat div meat_per_wrap, min_rice div rice_per_wrap) * 10: wraps;
var 0..max(min_meat div meat_per_platter, min_rice div rice_per_platter) * 10: platters;

var 0..(time_per_wrap * (max(min_meat div meat_per_wrap, min_rice div rice_per_wrap) * 10)
      + time_per_platter * (max(min_meat div meat_per_platter, min_rice div rice_per_platter) * 10)): total_time;

% Constraints
constraint meat_per_wrap * wraps + meat_per_platter * platters >= min_meat;
constraint rice_per_wrap * wraps + rice_per_platter * platters >= min_rice;

constraint wraps >= wrap_ratio * platters;

constraint total_time = time_per_wrap * wraps + time_per_platter * platters;

% Objective
solve minimize total_time;