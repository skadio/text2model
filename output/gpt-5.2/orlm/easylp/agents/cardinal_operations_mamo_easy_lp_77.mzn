% Parameters
int: max_effort = 120;          % Maximum allowed combined effort (hours) for 2*X + 3*Y
int: min_total_hours = 40;      % Minimum total allocated hours X + Y
int: coeff_x = 2;               % Coefficient of task X in combined effort constraint
int: coeff_y = 3;               % Coefficient of task Y in combined effort constraint
int: cost_x = 50;               % Cost per hour of task X (dollars)
int: cost_y = 30;               % Cost per hour of task Y (dollars)

% Variables
var 0..max_effort: x_hours;     % Integer hours allocated to task X (non-negative)
var 0..max_effort: y_hours;     % Integer hours allocated to task Y (non-negative)
var 0..(cost_x*max_effort + cost_y*max_effort): total_cost; % Total cost in dollars (integer)

% Constraints
% Combined effort limit: 2*X + 3*Y must not exceed max_effort
constraint
  coeff_x * x_hours + coeff_y * y_hours <= max_effort;

% Minimum total allocated hours across both tasks
constraint
  x_hours + y_hours >= min_total_hours;

% Define total cost from allocated hours and per-hour costs
constraint
  total_cost = cost_x * x_hours + cost_y * y_hours;

% Objective
solve minimize total_cost;