% Parameters
int: time_per_unit_cleansing = 4;          % Minutes per unit of cleansing chemical
int: time_per_unit_odor = 6;               % Minutes per unit of odor-removing chemical

int: min_cleansing_units = 100;            % Must use at least this many units of cleansing chemical
int: min_total_units = 300;                % Must use at least this many total units of chemicals
int: max_cleansing_to_odor_ratio = 2;      % Cleansing units <= ratio * odor units

% Variables
var 0..1000000: cleansing_units;           % Units of cleansing chemical used
var 0..1000000: odor_units;                % Units of odor-removing chemical used
var 0..1000000000: total_time;             % Total cleaning time in minutes

% Constraints
% Link total_time to the amounts of each chemical used
constraint
  total_time = time_per_unit_cleansing * cleansing_units
             + time_per_unit_odor * odor_units;

% Minimum required cleansing chemical usage
constraint
  cleansing_units >= min_cleansing_units;

% Minimum total chemical usage
constraint
  cleansing_units + odor_units >= min_total_units;

% Ratio restriction: cleansing chemical cannot exceed a multiple of odor-removing chemical
constraint
  cleansing_units <= max_cleansing_to_odor_ratio * odor_units;

% Objective
solve minimize total_time;