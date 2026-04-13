% Parameters
float: leg_per_dose_pk1 = 0.5;
float: back_per_dose_pk1 = 0.8;
float: sleep_per_dose_pk1 = 0.3;

float: leg_per_dose_pk2 = 0.7;
float: back_per_dose_pk2 = 0.4;
float: sleep_per_dose_pk2 = 0.6;

float: max_sleep = 8.0;
float: min_leg = 4.0;

% Variables
var 0..26: x1; % doses of pain killer 1
var 0..13: x2; % doses of pain killer 2

% Constraints
constraint sleep_per_dose_pk1 * x1 + sleep_per_dose_pk2 * x2 <= max_sleep;
constraint leg_per_dose_pk1 * x1 + leg_per_dose_pk2 * x2 >= min_leg;

% Objective
solve maximize back_per_dose_pk1 * x1 + back_per_dose_pk2 * x2;