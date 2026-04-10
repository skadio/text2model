% Parameters
int: total_hours_limit = 40;                 % Total available hours for both tasks
int: min_combined_effort = 20;               % Minimum required: 2*X + Y >= this value
int: max_hour_difference = 10;               % Constraint: |X - Y| <= this value

int: cost_per_hour_x = 8;                    % Cost per hour for Task X
int: cost_per_hour_y = 10;                   % Cost per hour for Task Y

int: max_hours_x = 25;                       % Upper bound on hours for Task X
int: max_hours_y = 15;                       % Upper bound on hours for Task Y


% Variables
var 0..max_hours_x: hours_x;                 % Integer hours allocated to Task X
var 0..max_hours_y: hours_y;                 % Integer hours allocated to Task Y

% Total cost upper bound based on maxima (safe bound for the objective variable)
int: max_total_cost = cost_per_hour_x * max_hours_x + cost_per_hour_y * max_hours_y;
var 0..max_total_cost: total_cost;           % Total cost (bounded)


% Constraints
% --- Hours budget constraint (total allocated hours cannot exceed the limit)
constraint hours_x + hours_y <= total_hours_limit;

% --- Minimum combined effort constraint (2*X + Y must reach the required threshold)
constraint 2 * hours_x + hours_y >= min_combined_effort;

% --- Balance constraint (tasks should progress similarly: |X - Y| <= max difference)
constraint abs(hours_x - hours_y) <= max_hour_difference;

% --- Cost definition (total cost computed from per-hour costs and allocated hours)
constraint total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;


% Objective
solve minimize total_cost;

output [
  "hours_x=", show(hours_x), "\n",
  "hours_y=", show(hours_y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];