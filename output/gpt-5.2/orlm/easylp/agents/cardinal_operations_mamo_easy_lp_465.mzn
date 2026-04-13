% Parameters
% Minimum hours required for each team
int: min_hours_x = 10;
int: min_hours_y = 5;

% Maximum total hours allowed
int: max_total_hours = 40;

% Cost per hour for each team (in dollars)
int: cost_per_hour_x = 50;
int: cost_per_hour_y = 80;

% Variables
% Allocated whole-number hours to each team
var min_hours_x..max_total_hours: hours_x;
var min_hours_y..max_total_hours: hours_y;

% Total cost (in dollars), upper-bounded by allocating all max hours at the higher hourly cost
var 0..(max_total_hours * max(cost_per_hour_x, cost_per_hour_y)): total_cost;

% Constraints
% Enforce minimum hours (redundant with domains, kept for clarity)
constraint hours_x >= min_hours_x /\ hours_y >= min_hours_y;

% Total allocated hours cannot exceed the maximum allowed
constraint hours_x + hours_y <= max_total_hours;

% Define total cost from hours and per-hour costs
constraint total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;

% Objective
solve minimize total_cost;