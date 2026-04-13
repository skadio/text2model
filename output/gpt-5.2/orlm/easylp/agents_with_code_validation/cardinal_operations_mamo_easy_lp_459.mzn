% Parameters
int: min_total_hours = 50;                 % Minimum combined hours for tasks X and Y
int: max_weighted_hours = 120;             % Maximum for (2*X + Y)
int: cost_per_hour_x = 8;                  % Cost per hour for task X
int: cost_per_hour_y = 10;                 % Cost per hour for task Y

% Variables
var 0..max_weighted_hours: hours_x;        % Whole hours allocated to task X
var 0..max_weighted_hours: hours_y;        % Whole hours allocated to task Y
var 0..(cost_per_hour_x*max_weighted_hours + cost_per_hour_y*max_weighted_hours): total_cost; % Total cost (integer)

% Constraints
% Minimum combined hours requirement
constraint hours_x + hours_y >= min_total_hours;

% Maximum weighted hours limit: (2*X + Y) must not exceed the allowed bound
constraint 2 * hours_x + hours_y <= max_weighted_hours;

% Task X should have at least as many hours as task Y
constraint hours_x >= hours_y;

% Define total cost from hourly allocations and per-hour costs
constraint total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;

% Objective
solve minimize total_cost;