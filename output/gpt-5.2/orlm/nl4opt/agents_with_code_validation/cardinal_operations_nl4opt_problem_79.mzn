% Parameters
% Per-dose delivery (embedded from problem statement)
float: leg_per_dose_pk1   = 0.5;
float: back_per_dose_pk1  = 0.8;
float: sleep_per_dose_pk1 = 0.3;

float: leg_per_dose_pk2   = 0.7;
float: back_per_dose_pk2  = 0.4;
float: sleep_per_dose_pk2 = 0.6;

% Requirements / limits (embedded from problem statement)
float: min_leg_medicine   = 4.0;  % at least this much to legs
float: max_sleep_medicine = 8.0;  % at most this much sleep medicine


% Variables
% Number of doses to take of each pain killer (non-negative integers)
var 0..100: doses_pk1;   % doses of pain killer 1
var 0..100: doses_pk2;   % doses of pain killer 2

% Total delivered amounts (bounded floats; bounds chosen to cover feasible region)
var 0.0..1000.0: total_leg_medicine;    % total medicine delivered to legs
var 0.0..1000.0: total_back_medicine;   % total medicine delivered to back (objective)
var 0.0..1000.0: total_sleep_medicine;  % total sleeping medicine delivered


% Constraints
% --- Total medicine calculations (link totals to decision variables) ---
constraint
  total_leg_medicine =
    leg_per_dose_pk1 * doses_pk1 + leg_per_dose_pk2 * doses_pk2;

constraint
  total_back_medicine =
    back_per_dose_pk1 * doses_pk1 + back_per_dose_pk2 * doses_pk2;

constraint
  total_sleep_medicine =
    sleep_per_dose_pk1 * doses_pk1 + sleep_per_dose_pk2 * doses_pk2;

% --- Clinical requirements / limits ---
constraint total_leg_medicine >= min_leg_medicine;
constraint total_sleep_medicine <= max_sleep_medicine;


% Objective
solve maximize total_back_medicine;