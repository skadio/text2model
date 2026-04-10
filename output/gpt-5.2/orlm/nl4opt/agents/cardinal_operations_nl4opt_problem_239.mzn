% Parameters
% Per-pill medication and discharge contributions (embedded from description)
float: pain_per_pill1         = 0.2;
float: anxiety_per_pill1      = 0.3;
float: discharge_per_pill1    = 0.3;

float: pain_per_pill2         = 0.6;
float: anxiety_per_pill2      = 0.2;
float: discharge_per_pill2    = 0.1;

% Requirements
float: pain_max               = 6.0;  % at most
float: anxiety_min            = 3.0;  % at least


% Variables
% Number of pills of each type (nonnegative integers)
var 0..100: pills1; % number of Pill 1
var 0..100: pills2; % number of Pill 2


% Constraints
% --- Pain medication limit (at most pain_max) ---
constraint
  pain_per_pill1 * pills1 + pain_per_pill2 * pills2 <= pain_max;

% --- Anxiety medication requirement (at least anxiety_min) ---
constraint
  anxiety_per_pill1 * pills1 + anxiety_per_pill2 * pills2 >= anxiety_min;


% Objective
% Minimize total discharge from both pill types
solve minimize discharge_per_pill1 * pills1 + discharge_per_pill2 * pills2;