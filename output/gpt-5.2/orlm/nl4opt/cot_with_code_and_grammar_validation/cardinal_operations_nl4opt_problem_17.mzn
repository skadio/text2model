% Parameters
int: time_cleanse = 4;          % minutes per unit of cleansing chemical
int: time_odor = 6;             % minutes per unit of odor-removing chemical
int: min_cleanse = 100;         % minimum units of cleansing chemical
int: min_total = 300;           % minimum total units of chemicals

% Variables
var 0..1000000: x;              % units of cleansing chemical
var 0..1000000: y;              % units of odor-removing chemical
var 0..1000000000: total_time;  % total time in minutes

% Constraints
constraint x >= min_cleanse;
constraint x + y >= min_total;
constraint x <= 2 * y;

constraint total_time = time_cleanse * x + time_odor * y;

% Objective
solve minimize total_time;