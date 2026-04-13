% Parameters
int: max_total_hours = 15;                 % Total weekly hours available for training
int: min_strength_hours = 5;               % Minimum required hours of strength conditioning (X)
int: min_skill_hours = 3;                  % Minimum required hours of skill development (Y)
int: fatigue_per_strength_hour = 20;       % Fatigue units per hour of strength conditioning
int: fatigue_per_skill_hour = 30;          % Fatigue units per hour of skill development

% Variables
var min_strength_hours..max_total_hours: X;  % Weekly hours of strength conditioning (integer)
var min_skill_hours..max_total_hours: Y;     % Weekly hours of skill development (integer)
var 0..(fatigue_per_strength_hour*max_total_hours
       + fatigue_per_skill_hour*max_total_hours): total_fatigue; % Total fatigue score

% Constraints
% Time feasibility: total weekly hours for both activities cannot exceed the available limit
constraint
  X + Y <= max_total_hours;

% Fatigue accounting: total fatigue equals the sum of per-hour fatigue contributions
constraint
  total_fatigue =
    fatigue_per_strength_hour * X + fatigue_per_skill_hour * Y;

% Objective
solve minimize total_fatigue;