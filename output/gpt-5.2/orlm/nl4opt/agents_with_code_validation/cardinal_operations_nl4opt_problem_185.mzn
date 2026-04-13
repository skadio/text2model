% Parameters
int: meat_per_wrap    = 5;    % Meat units required per wrap
int: rice_per_wrap    = 3;    % Rice units required per wrap
int: time_per_wrap    = 10;   % Minutes to make one wrap

int: meat_per_platter = 7;    % Meat units required per platter
int: rice_per_platter = 5;    % Rice units required per platter
int: time_per_platter = 8;    % Minutes to make one platter

int: min_meat = 3000;         % Minimum meat units that must be used
int: min_rice = 2500;         % Minimum rice units that must be used

int: wrap_to_platter_ratio = 3; % Must make at least this many wraps per platter


% Variables
% Upper bounds chosen from meeting each minimum using only that product type.
var 0..max(min_meat div meat_per_wrap, min_rice div rice_per_wrap): wraps;       
var 0..max(min_meat div meat_per_platter, min_rice div rice_per_platter): platters;

% Total production time (minutes), with a safe derived upper bound.
var 0..(
  time_per_wrap * max(min_meat div meat_per_wrap, min_rice div rice_per_wrap)
+ time_per_platter * max(min_meat div meat_per_platter, min_rice div rice_per_platter)
): total_time;


% Constraints
% Meet minimum meat requirement
constraint meat_per_wrap * wraps + meat_per_platter * platters >= min_meat;

% Meet minimum rice requirement
constraint rice_per_wrap * wraps + rice_per_platter * platters >= min_rice;

% At least 3 times as many wraps as platters
constraint wraps >= wrap_to_platter_ratio * platters;

% Define total production time
constraint total_time = time_per_wrap * wraps + time_per_platter * platters;


% Objective
solve minimize total_time;