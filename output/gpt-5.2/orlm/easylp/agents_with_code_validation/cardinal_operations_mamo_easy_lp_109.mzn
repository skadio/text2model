% Parameters
int: min_total_time = 15;          % Minimum combined training hours required
int: max_weighted_time = 40;       % Maximum allowed for 2*x + y due to facility constraints
int: cost_per_hour_x = 20;         % Cost per hour for exercise X
int: cost_per_hour_y = 30;         % Cost per hour for exercise Y

% Variables
var 0..max_weighted_time: x;       % Whole hours assigned to exercise X (non-negative)
var 0..max_weighted_time: y;       % Whole hours assigned to exercise Y (non-negative)
var 0..(cost_per_hour_x * max_weighted_time + cost_per_hour_y * max_weighted_time): total_cost;
                                   % Total training cost (bounded)

% Constraints
% Minimum combined training time requirement
constraint x + y >= min_total_time;

% Facility constraint: weighted total time limit (2*x + y)
constraint 2 * x + y <= max_weighted_time;

% Define total training cost from per-hour costs and allocated hours
constraint total_cost = cost_per_hour_x * x + cost_per_hour_y * y;

% Objective
solve minimize total_cost;