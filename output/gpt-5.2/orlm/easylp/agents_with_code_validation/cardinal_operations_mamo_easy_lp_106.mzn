% Parameters
int: intensity_per_hour_X = 8;      % intensity units per hour for exercise X
int: intensity_per_hour_Y = 12;     % intensity units per hour for exercise Y
int: max_total_hours = 20;          % maximum total training hours allowed

int: effectiveness_weight_X = 5;    % effectiveness contribution per hour of X
int: effectiveness_weight_Y = 3;    % effectiveness contribution per hour of Y
int: min_effectiveness = 15;        % minimum required effectiveness points

% Variables
var 0..max_total_hours: hours_X;    % whole hours spent on exercise X
var 0..max_total_hours: hours_Y;    % whole hours spent on exercise Y

var 0..(intensity_per_hour_X*max_total_hours + intensity_per_hour_Y*max_total_hours): total_intensity;
% total intensity score to minimize

% Constraints
% Total training time limit (hours on X and Y cannot exceed max_total_hours)
constraint
  hours_X + hours_Y <= max_total_hours;

% Minimum required effectiveness must be met
constraint
  effectiveness_weight_X * hours_X + effectiveness_weight_Y * hours_Y >= min_effectiveness;

% Define total intensity as the weighted sum of hours spent on each exercise
constraint
  total_intensity = intensity_per_hour_X * hours_X + intensity_per_hour_Y * hours_Y;

% Objective
solve minimize total_intensity;