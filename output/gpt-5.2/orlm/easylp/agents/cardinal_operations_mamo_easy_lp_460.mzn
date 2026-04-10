% Parameters
int: total_hours_limit = 40;          % Maximum total allocatable hours
int: min_effort_requirement = 20;     % Minimum required effort: 2*X + Y >= 20
int: max_hour_difference = 10;        % |X - Y| <= 10

int: cost_per_hour_x = 8;             % Cost per hour for Task X
int: cost_per_hour_y = 10;            % Cost per hour for Task Y

int: max_hours_x = 25;                % Upper bound on hours for Task X
int: max_hours_y = 15;                % Upper bound on hours for Task Y


% Variables
var 0..max_hours_x: hours_x;          % Integer hours allocated to Task X
var 0..max_hours_y: hours_y;          % Integer hours allocated to Task Y

% Total cost variable (bounded by max feasible spend)
var 0..(cost_per_hour_x*max_hours_x + cost_per_hour_y*max_hours_y): total_cost;


% Constraints
% Total allocated hours must not exceed the overall time limit
constraint hours_x + hours_y <= total_hours_limit;

% Minimum required effort to meet deadlines: 2*X + Y >= required effort
constraint 2 * hours_x + hours_y >= min_effort_requirement;

% Keep task progress similar: absolute difference in hours is bounded
constraint abs(hours_x - hours_y) <= max_hour_difference;

% Define total cost from per-hour costs and allocated hours
constraint total_cost = cost_per_hour_x * hours_x + cost_per_hour_y * hours_y;


% Objective
solve minimize total_cost;

output [
  "hours_x=", show(hours_x), "\n",
  "hours_y=", show(hours_y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];