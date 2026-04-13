% Parameters
int: time_per_unit_anxiety = 3;          % minutes per unit of anxiety medication
int: time_per_unit_antidepressant = 5;   % minutes per unit of anti-depressant

int: min_total_units = 100;             % minimum total units of medication
int: min_anxiety_units = 30;            % minimum units of anxiety medication
int: max_anxiety_factor = 2;            % anxiety units <= factor * anti-depressant units

% Variables
var 0..min_total_units: anxiety_units;                 % units of anxiety medication
var 0..min_total_units: antidepressant_units;          % units of anti-depressants
var 0..(time_per_unit_anxiety * min_total_units
      + time_per_unit_antidepressant * min_total_units): total_time; % total minutes

% Constraints
% Total units requirement: at least the minimum total medication units
constraint
  anxiety_units + antidepressant_units >= min_total_units;

% Minimum anxiety medication requirement
constraint
  anxiety_units >= min_anxiety_units;

% Strength/ratio constraint: anxiety medication is at most a factor times anti-depressants
constraint
  anxiety_units <= max_anxiety_factor * antidepressant_units;

% Total time definition (linear relationship)
constraint
  total_time = time_per_unit_anxiety * anxiety_units
             + time_per_unit_antidepressant * antidepressant_units;

% Objective
solve minimize total_time;