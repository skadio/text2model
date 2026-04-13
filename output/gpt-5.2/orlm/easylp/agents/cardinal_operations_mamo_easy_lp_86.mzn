% Parameters
int: max_total_hours = 24;          % Maximum combined hours per week (labor law)
int: min_hours_X = 4;              % Minimum required hours for team X
int: min_hours_Y = 6;              % Minimum required hours for team Y
int: cost_per_hour_X = 8;          % Cost per hour for team X (dollars)
int: cost_per_hour_Y = 10;         % Cost per hour for team Y (dollars)

% Variables
var min_hours_X..max_total_hours: hours_X;   % Scheduled whole hours for team X
var min_hours_Y..max_total_hours: hours_Y;   % Scheduled whole hours for team Y
var 0..(cost_per_hour_X*max_total_hours + cost_per_hour_Y*max_total_hours): total_cost; % Total weekly cost

% Constraints
%--- Total hours limit (labor law) ---
constraint
  hours_X + hours_Y <= max_total_hours;

%--- Minimum operational requirements (already ensured by variable domains; stated explicitly for clarity) ---
constraint
  hours_X >= min_hours_X;

constraint
  hours_Y >= min_hours_Y;

%--- Total cost definition ---
constraint
  total_cost = cost_per_hour_X * hours_X + cost_per_hour_Y * hours_Y;

% Objective
solve minimize total_cost;