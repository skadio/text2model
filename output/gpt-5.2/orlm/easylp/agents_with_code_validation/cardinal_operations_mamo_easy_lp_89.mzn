% Parameters
int: min_total_hours = 10;          % Minimum combined hours required for tasks X and Y
int: max_weighted_hours = 24;       % Maximum allowed value of 2*X + 3*Y
int: weight_x = 2;                  % Weight multiplier for task X in the resource constraint
int: weight_y = 3;                  % Weight multiplier for task Y in the resource constraint
int: cost_per_hour_x = 8;           % Cost per hour for task X
int: cost_per_hour_y = 5;           % Cost per hour for task Y

% Variables
var 0..max_weighted_hours: hours_x; % Integer hours allocated to task X (bounded non-negative)
var 0..max_weighted_hours: hours_y; % Integer hours allocated to task Y (bounded non-negative)

% Total cost to minimize (safe explicit upper bound)
var 0..(cost_per_hour_x * max_weighted_hours + cost_per_hour_y * max_weighted_hours): total_cost;

% Constraints
% Minimum combined workload requirement
constraint
  hours_x + hours_y >= min_total_hours;

% Resource limitation: weighted hours must not exceed maximum
constraint
  weight_x * hours_x + weight_y * hours_y <= max_weighted_hours;

% Total cost definition (linking objective variable to decision variables)
constraint
  total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;

% Objective
solve minimize total_cost;