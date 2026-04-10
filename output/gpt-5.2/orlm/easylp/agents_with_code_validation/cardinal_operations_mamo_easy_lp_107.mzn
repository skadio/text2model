% Parameters
int: max_total_hours = 50;          % Upper bound on total weekly training hours
int: min_effectiveness = 20;        % Minimum required effectiveness score

int: eff_x = 2;                     % Effectiveness points per hour of workout X
int: eff_y = 1;                     % Effectiveness points per hour of workout Y

int: diff_limit = 10;               % Limit for |X - 3*Y|
int: diff_y_multiplier = 3;         % Multiplier on Y in the balance constraint

int: fatigue_x = 5;                 % Fatigue cost per hour of workout X
int: fatigue_y = 3;                 % Fatigue cost per hour of workout Y

% Variables
var 0..max_total_hours: hours_x;    % Integer hours allocated to workout X
var 0..max_total_hours: hours_y;    % Integer hours allocated to workout Y

var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours): total_fatigue; % Total fatigue cost

% Constraints
% Total-hours capacity: combined training hours cannot exceed the weekly limit
constraint hours_x + hours_y <= max_total_hours;

% Minimum effectiveness requirement: eff_x*X + eff_y*Y must reach the target
constraint eff_x * hours_x + eff_y * hours_y >= min_effectiveness;

% Balanced training schedule: |X - diff_y_multiplier*Y| must be within diff_limit
constraint abs(hours_x - diff_y_multiplier * hours_y) <= diff_limit;

% Define total fatigue cost from allocated hours
constraint total_fatigue = fatigue_x * hours_x + fatigue_y * hours_y;

% Objective
solve minimize total_fatigue;