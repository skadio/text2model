% Parameters
int: min_total_hours = 50;          % Minimum combined hours for tasks X and Y
int: max_weighted_hours = 120;      % Maximum allowed value of 2*X + Y
int: cost_per_hour_x = 8;           % Cost per hour for task X
int: cost_per_hour_y = 10;          % Cost per hour for task Y

% Variables
var 0..max_weighted_hours: hours_x; % Integer hours allocated to task X (bounded above for safety)
var 0..max_weighted_hours: hours_y; % Integer hours allocated to task Y (bounded above for safety)

% Total cost (bounded using worst-case upper bounds)
var 0..(cost_per_hour_x*max_weighted_hours + cost_per_hour_y*max_weighted_hours): total_cost;

% Constraints
% Minimum combined hours requirement
constraint
  hours_x + hours_y >= min_total_hours;

% Maximum weighted-hours capacity: 2*X + Y must not exceed limit
constraint
  2 * hours_x + hours_y <= max_weighted_hours;

% Task X allocation must be at least task Y allocation
constraint
  hours_x >= hours_y;

% Define total cost from per-hour costs and allocated hours
constraint
  total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;

% Objective
solve minimize total_cost;

% Output
output [
  "hours_x=", show(hours_x), "\n",
  "hours_y=", show(hours_y), "\n",
  "total_cost=", show(total_cost), "\n"
];