% Parameters
int: intensity_x = 8;          % intensity units per hour for exercise X
int: intensity_y = 12;         % intensity units per hour for exercise Y
int: max_total_hours = 20;     % maximum total hours allowed
int: eff_coef_x = 5;           % effectiveness coefficient for X (points per hour)
int: eff_coef_y = 3;           % effectiveness coefficient for Y (points per hour)
int: min_effectiveness = 15;   % minimum required effectiveness points

% Variables
var 0..max_total_hours: hours_x;   % whole hours spent on exercise X
var 0..max_total_hours: hours_y;   % whole hours spent on exercise Y
var 0..(intensity_x*max_total_hours + intensity_y*max_total_hours): total_intensity;
% total intensity score (objective value)

% Constraints
% Time budget: total hours on exercises X and Y must not exceed the maximum
constraint
  hours_x + hours_y <= max_total_hours;

% Minimum effectiveness requirement: combined effectiveness must meet or exceed target
constraint
  eff_coef_x * hours_x + eff_coef_y * hours_y >= min_effectiveness;

% Define total intensity as the weighted sum of hours spent on each exercise
constraint
  total_intensity = intensity_x * hours_x + intensity_y * hours_y;

% Objective
solve minimize total_intensity;