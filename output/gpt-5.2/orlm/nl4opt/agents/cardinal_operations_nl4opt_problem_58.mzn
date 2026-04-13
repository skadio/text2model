% Parameters
int: time_calcium = 5;          % minutes per calcium pill to be effective
int: time_vitaminD = 6;         % minutes per vitamin D pill to be effective
int: min_total_pills = 130;     % minimum total pills over the month
int: min_vitaminD_pills = 40;   % minimum vitamin D pills required

% Variables
var 0..min_total_pills: calcium_pills;   % number of calcium pills taken
var 0..min_total_pills: vitaminD_pills;  % number of vitamin D pills taken
var 0..(time_calcium*min_total_pills + time_vitaminD*min_total_pills): total_time;
                                        % total time for all pills to be effective (minutes)

% Constraints
% Link total_time to the number of pills and their effectiveness times
constraint
  total_time = time_calcium * calcium_pills + time_vitaminD * vitaminD_pills;

% Ensure minimum total number of pills taken over the month
constraint
  calcium_pills + vitaminD_pills >= min_total_pills;

% Ensure minimum number of vitamin D pills (to enhance calcium absorption)
constraint
  vitaminD_pills >= min_vitaminD_pills;

% Ensure vitamin D pills are fewer than calcium pills (more calcium than vitamin D)
constraint
  calcium_pills > vitaminD_pills;

% Objective
solve minimize total_time;