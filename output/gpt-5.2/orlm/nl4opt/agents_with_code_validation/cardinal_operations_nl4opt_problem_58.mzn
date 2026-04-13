% Parameters
int: time_calcium = 5;          % Minutes for one calcium pill to be effective
int: time_vitD = 6;             % Minutes for one vitamin D pill to be effective
int: min_total_pills = 130;     % Minimum total pills over the month
int: min_vitD_pills = 40;       % Minimum vitamin D pills over the month

% Variables
var 0..min_total_pills: calcium_pills;  % Number of calcium pills taken
var 0..min_total_pills: vitD_pills;     % Number of vitamin D pills taken
var 0..(time_calcium*min_total_pills + time_vitD*min_total_pills): total_time; % Total effective time (minutes)

% Constraints
% Link total_time to the pill counts and their effectiveness times
constraint
  total_time = time_calcium * calcium_pills + time_vitD * vitD_pills;

% Minimum total number of pills taken over the month
constraint
  calcium_pills + vitD_pills >= min_total_pills;

% Minimum number of vitamin D pills required
constraint
  vitD_pills >= min_vitD_pills;

% Vitamin D is complementary; must take more calcium pills than vitamin D pills
constraint
  calcium_pills > vitD_pills;

% Objective
solve minimize total_time;