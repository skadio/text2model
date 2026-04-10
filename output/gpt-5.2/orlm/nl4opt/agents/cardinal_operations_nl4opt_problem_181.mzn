% Parameters
int: time_per_unit_anxiety = 3;          % minutes per unit of anxiety medication
int: time_per_unit_antidepressant = 5;   % minutes per unit of anti-depressant

int: min_total_units = 100;             % must take at least this many total units
int: min_anxiety_units = 30;            % must take at least this many anxiety units
int: max_anxiety_ratio = 2;             % anxiety units <= 2 * anti-depressant units


% Variables
var 0..min_total_units: anxiety_units;                 % number of anxiety medication units
var 0..min_total_units: antidepressant_units;          % number of anti-depressant units
var 0..(time_per_unit_anxiety*min_total_units
      + time_per_unit_antidepressant*min_total_units): total_time; % total time (minutes)


% Constraints
% Link total_time to the chosen medication quantities
constraint
  total_time = time_per_unit_anxiety * anxiety_units
             + time_per_unit_antidepressant * antidepressant_units;

% Minimum total medication units requirement
constraint
  anxiety_units + antidepressant_units >= min_total_units;

% Minimum anxiety medication units requirement
constraint
  anxiety_units >= min_anxiety_units;

% Strength ratio constraint: anxiety medication is at most twice anti-depressants
constraint
  anxiety_units <= max_anxiety_ratio * antidepressant_units;


% Objective
solve minimize total_time;