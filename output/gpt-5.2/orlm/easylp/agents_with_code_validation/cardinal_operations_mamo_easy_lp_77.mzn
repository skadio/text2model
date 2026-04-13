% Parameters
int: max_effort = 120;          % Maximum allowed combined effort (hours)
int: min_total_hours = 40;      % Minimum total hours allocated to tasks X and Y

int: coef_X = 2;                % Effort coefficient for task X in combined-effort constraint
int: coef_Y = 3;                % Effort coefficient for task Y in combined-effort constraint

int: cost_X = 50;               % Cost per hour for task X ($/hour)
int: cost_Y = 30;               % Cost per hour for task Y ($/hour)

% Variables
var 0..max_effort: hours_X;     % Integer hours allocated to task X
var 0..max_effort: hours_Y;     % Integer hours allocated to task Y

var 0..(cost_X*max_effort + cost_Y*max_effort): total_cost; % Total cost in dollars (integer)

% Constraints

% Link total_cost to the chosen hours (linear cost definition)
constraint
  total_cost = cost_X * hours_X + cost_Y * hours_Y;

% Combined-effort (time) limit: 2*X + 3*Y must not exceed max_effort
constraint
  coef_X * hours_X + coef_Y * hours_Y <= max_effort;

% Minimum total allocated hours across both tasks
constraint
  hours_X + hours_Y >= min_total_hours;

% Objective
solve minimize total_cost;