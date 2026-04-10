% Parameters
int: max_total_hours = 40;          % Maximum combined training hours per week
int: min_hours_X = 15;             % Minimum required hours for workout X
int: min_hours_Y = 10;             % Minimum required hours for workout Y
int: fatigue_per_hour_X = 2;       % Fatigue points per hour of workout X
int: fatigue_per_hour_Y = 3;       % Fatigue points per hour of workout Y

% Variables
var min_hours_X..max_total_hours: hours_X;   % Scheduled full hours for workout X
var min_hours_Y..max_total_hours: hours_Y;   % Scheduled full hours for workout Y
var 0..(fatigue_per_hour_X*max_total_hours + fatigue_per_hour_Y*max_total_hours): total_fatigue; % Total fatigue points

% Constraints
% Total hours limit (combined weekly training cannot exceed the maximum)
constraint hours_X + hours_Y <= max_total_hours;

% Total fatigue calculation (linear relation between hours and fatigue points)
constraint total_fatigue = fatigue_per_hour_X * hours_X
                         + fatigue_per_hour_Y * hours_Y;

% Objective
solve minimize total_fatigue;