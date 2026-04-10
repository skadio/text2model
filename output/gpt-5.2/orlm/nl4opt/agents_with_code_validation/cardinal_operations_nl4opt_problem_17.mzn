% Parameters
int: time_per_unit_cleansing = 4;          % minutes per unit of cleansing chemical
int: time_per_unit_odor = 6;               % minutes per unit of odor-removing chemical
int: min_cleansing_units = 100;            % minimum units of cleansing chemical required
int: min_total_units = 300;                % minimum total units of chemicals required
int: max_cleansing_ratio = 2;              % cleansing units <= 2 * odor units

% Variables
var 0..1000000: cleansing_units;           % units of cleansing chemical used
var 0..1000000: odor_units;                % units of odor-removing chemical used
var 0..1000000000: total_time;             % total cleaning time in minutes

% Constraints
% Total time definition (linear relation between units used and time per unit)
constraint
  total_time = time_per_unit_cleansing * cleansing_units
             + time_per_unit_odor * odor_units;

% Minimum cleansing chemical usage requirement
constraint
  cleansing_units >= min_cleansing_units;

% Minimum total chemical usage requirement
constraint
  cleansing_units + odor_units >= min_total_units;

% Strength/risk constraint: cleansing chemical cannot exceed ratio relative to odor chemical
constraint
  cleansing_units <= max_cleansing_ratio * odor_units;

% Objective
solve minimize total_time;