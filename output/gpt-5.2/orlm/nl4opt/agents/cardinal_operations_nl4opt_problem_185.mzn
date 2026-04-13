% Parameters
% Resource use per product
int: meat_per_wrap    = 5;
int: rice_per_wrap    = 3;
int: meat_per_platter = 7;
int: rice_per_platter = 5;

% Time per product (minutes)
int: time_per_wrap    = 10;
int: time_per_platter = 8;

% Minimum required resources to use
int: min_meat = 3000;
int: min_rice = 2500;

% Wrap-to-platter ratio requirement
int: wrap_ratio = 3;

% Upper bounds (derived to keep variables bounded)
% Use integer arithmetic with ceiling: ceil(a/b) = (a + b - 1) div b
int: max_wraps =
  max( (min_meat + meat_per_wrap - 1) div meat_per_wrap,
       (min_rice + rice_per_wrap - 1) div rice_per_wrap );

int: max_platters =
  max( (min_meat + meat_per_platter - 1) div meat_per_platter,
       (min_rice + rice_per_platter - 1) div rice_per_platter );

% Variables
var 0..max_wraps: wraps;            % number of wraps to make
var 0..max_platters: platters;      % number of platters to make

var 0..(time_per_wrap * max_wraps + time_per_platter * max_platters): total_time; % total production time

% Constraints
% Resource usage must meet minimum required amounts
constraint
  meat_per_wrap * wraps + meat_per_platter * platters >= min_meat; % minimum meat usage

constraint
  rice_per_wrap * wraps + rice_per_platter * platters >= min_rice; % minimum rice usage

% Wraps must be at least `wrap_ratio` times the number of platters
constraint
  wraps >= wrap_ratio * platters; % wrap-to-platter ratio requirement

% Define total production time from decision variables
constraint
  total_time = time_per_wrap * wraps + time_per_platter * platters; % total time calculation

% Objective
solve minimize total_time;