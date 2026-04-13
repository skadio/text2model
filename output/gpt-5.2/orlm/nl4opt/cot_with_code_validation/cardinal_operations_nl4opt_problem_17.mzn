% Parameters
int: time_cleansing = 4;
int: time_odor = 6;

int: min_cleansing = 100;
int: min_total = 300;
int: max_cleansing_factor = 2;

% Variables
var 0..1000000: x_cleansing;
var 0..1000000: x_odor;
var 0..10000000: total_time;

% Constraints
constraint x_cleansing >= min_cleansing;
constraint x_cleansing + x_odor >= min_total;
constraint x_cleansing <= max_cleansing_factor * x_odor;

constraint total_time = time_cleansing * x_cleansing + time_odor * x_odor;

% Objective
solve minimize total_time;