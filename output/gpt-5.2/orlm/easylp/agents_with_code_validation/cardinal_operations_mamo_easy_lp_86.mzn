% Parameters
int: max_total_hours = 24;         % Maximum combined hours for teams X and Y per week
int: min_hours_x = 4;              % Minimum hours required for team X
int: min_hours_y = 6;              % Minimum hours required for team Y
int: cost_per_hour_x = 8;          % Cost per hour for team X (dollars)
int: cost_per_hour_y = 10;         % Cost per hour for team Y (dollars)

% Variables
var min_hours_x..max_total_hours: hours_x;  % Scheduled whole hours for team X
var min_hours_y..max_total_hours: hours_y;  % Scheduled whole hours for team Y
var 0..(cost_per_hour_x*max_total_hours + cost_per_hour_y*max_total_hours): total_cost; % Total weekly cost (dollars)

% Constraints
% Combined weekly hours limit (labor law)
constraint hours_x + hours_y <= max_total_hours;

% Minimum operational requirements for each team
constraint hours_x >= min_hours_x;
constraint hours_y >= min_hours_y;

% Total cost definition
constraint total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;

% Objective
solve minimize total_cost;