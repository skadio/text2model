% Parameters
% Medication per pill (embedded from problem statement)
float: pain_per_pill1         = 0.2;
float: anxiety_per_pill1      = 0.3;
float: discharge_per_pill1    = 0.3;

float: pain_per_pill2         = 0.6;
float: anxiety_per_pill2      = 0.2;
float: discharge_per_pill2    = 0.1;

% Requirements (embedded from problem statement)
float: max_pain               = 6.0;  % at most
float: min_anxiety            = 3.0;  % at least


% Variables
% Number of pills of each type (nonnegative integers)
var 0..100: num_pill1;
var 0..100: num_pill2;

% Total discharge to minimize
var 0.0..1000.0: total_discharge;


% Constraints
% Link total_discharge to pill counts and per-pill discharge
constraint
  total_discharge =
    discharge_per_pill1 * num_pill1 +
    discharge_per_pill2 * num_pill2;

% Pain medication limit (at most max_pain)
constraint
  pain_per_pill1 * num_pill1 +
  pain_per_pill2 * num_pill2
  <= max_pain;

% Anxiety medication requirement (at least min_anxiety)
constraint
  anxiety_per_pill1 * num_pill1 +
  anxiety_per_pill2 * num_pill2
  >= min_anxiety;


% Objective
solve minimize total_discharge;