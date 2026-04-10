% Parameters
int: max_total_hours = 24;          % Maximum combined hours across teams
int: min_hours_x = 6;              % Minimum hours required for Team X
int: min_hours_y = 4;              % Minimum hours required for Team Y
int: min_hours_z = 2;              % Minimum hours required for Team Z

int: cost_per_hour_x = 8;          % Cost per hour for Team X
int: cost_per_hour_y = 5;          % Cost per hour for Team Y
int: cost_per_hour_z = 7;          % Cost per hour for Team Z

% Variables
var min_hours_x..max_total_hours: hours_x;    % Integer hours allocated to Team X
var min_hours_y..max_total_hours: hours_y;    % Integer hours allocated to Team Y
var min_hours_z..max_total_hours: hours_z;    % Integer hours allocated to Team Z

% Upper bound on total cost: all hours at the maximum per-hour cost
var 0..(max_total_hours * max([cost_per_hour_x, cost_per_hour_y, cost_per_hour_z])): total_cost;

% Constraints
% Total-hours capacity constraint (combined hours cannot exceed the limit)
constraint
  hours_x + hours_y + hours_z <= max_total_hours;

% Cost aggregation constraint (compute total cost from allocated hours)
constraint
  total_cost =
    cost_per_hour_x * hours_x +
    cost_per_hour_y * hours_y +
    cost_per_hour_z * hours_z;

% Objective
solve minimize total_cost;