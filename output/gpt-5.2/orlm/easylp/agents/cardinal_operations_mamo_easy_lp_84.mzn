% Parameters
int: max_total_hours = 40;            % Budget constraint: X + Y <= 40
int: min_output_units = 20;           % Timeline/output requirement: 2*X + Y >= 20
int: output_per_hour_X = 2;           % Output coefficient for team X hours
int: output_per_hour_Y = 1;           % Output coefficient for team Y hours
int: cost_per_hour_X = 8;             % Cost per hour for team X
int: cost_per_hour_Y = 6;             % Cost per hour for team Y

% Variables
var 0..max_total_hours: hours_X;      % Integer working hours allocated to team X
var 0..max_total_hours: hours_Y;      % Integer working hours allocated to team Y
var 0..(cost_per_hour_X*max_total_hours + cost_per_hour_Y*max_total_hours): total_cost;
                                      % Total cost to minimize (safe upper bound)

% Constraints
% Total hours budget: combined hours cannot exceed the maximum allowed
constraint hours_X + hours_Y <= max_total_hours;

% Minimum required output: output from X and Y must meet or exceed target units
constraint output_per_hour_X * hours_X + output_per_hour_Y * hours_Y >= min_output_units;

% Define total cost consistently with allocated hours and per-hour costs
constraint total_cost = cost_per_hour_X * hours_X + cost_per_hour_Y * hours_Y;

% Objective
solve minimize total_cost;