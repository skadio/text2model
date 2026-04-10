% Parameters
int: max_total_hours = 24;          % Maximum combined hours across teams
int: min_hours_X = 6;              % Minimum required hours for team X
int: min_hours_Y = 4;              % Minimum required hours for team Y
int: min_hours_Z = 2;              % Minimum required hours for team Z

int: cost_per_hour_X = 8;          % Cost per hour for team X
int: cost_per_hour_Y = 5;          % Cost per hour for team Y
int: cost_per_hour_Z = 7;          % Cost per hour for team Z

% Variables
var min_hours_X..max_total_hours: hours_X;   % Integer hours allocated to team X
var min_hours_Y..max_total_hours: hours_Y;   % Integer hours allocated to team Y
var min_hours_Z..max_total_hours: hours_Z;   % Integer hours allocated to team Z

var 0..(max_total_hours * max([cost_per_hour_X, cost_per_hour_Y, cost_per_hour_Z])): total_cost;
% Total cost in dollars (integer), bounded above by worst-case max-hours * max-cost

% Constraints
% Total hours capacity constraint (combined hours cannot exceed operational maximum)
constraint hours_X + hours_Y + hours_Z <= max_total_hours;

% Minimum hours requirements (redundant with variable lower bounds, kept for clarity/maintenance)
constraint hours_X >= min_hours_X;
constraint hours_Y >= min_hours_Y;
constraint hours_Z >= min_hours_Z;

% Total cost calculation constraint (link total_cost to allocated hours and per-hour costs)
constraint
  total_cost =
      cost_per_hour_X * hours_X
    + cost_per_hour_Y * hours_Y
    + cost_per_hour_Z * hours_Z;

% Objective
solve minimize total_cost;

% Optional output (keeps the model self-contained and shows the minimum cost found)
output [
  "hours_X=", show(hours_X), "\n",
  "hours_Y=", show(hours_Y), "\n",
  "hours_Z=", show(hours_Z), "\n",
  "total_cost=", show(total_cost), "\n"
];