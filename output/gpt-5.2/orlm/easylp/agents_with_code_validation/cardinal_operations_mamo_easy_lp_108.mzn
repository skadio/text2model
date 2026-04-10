% Parameters
int: max_total_hours = 20;           % Total weekly training time limit (X + Y)
int: min_extra_x_over_y = 5;         % X must be at least this many hours more than Y
int: fatigue_per_hour_x = 2;         % Fatigue units per hour of exercise X
int: fatigue_per_hour_y = 3;         % Fatigue units per hour of exercise Y
int: max_hours_x = 15;               % Upper bound on hours allocated to exercise X
int: max_hours_y = 10;               % Upper bound on hours allocated to exercise Y

% Variables
var 0..max_hours_x: hours_x;         % Integer hours for exercise X
var 0..max_hours_y: hours_y;         % Integer hours for exercise Y
var 0..(fatigue_per_hour_x*max_hours_x + fatigue_per_hour_y*max_hours_y): total_fatigue; % Total fatigue score

% Constraints
% Link total_fatigue to the chosen training hours
constraint
  total_fatigue = fatigue_per_hour_x * hours_x + fatigue_per_hour_y * hours_y;

% Total weekly training time limit
constraint
  hours_x + hours_y <= max_total_hours;

% Exercise X must be at least min_extra_x_over_y hours more than exercise Y
constraint
  hours_x >= hours_y + min_extra_x_over_y;

% Objective
solve minimize total_fatigue;