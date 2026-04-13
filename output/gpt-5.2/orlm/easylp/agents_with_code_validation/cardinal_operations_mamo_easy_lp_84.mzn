% Parameters
int: max_total_hours = 40;              % Maximum combined hours available (X + Y <= 40)
int: min_output_units = 20;             % Minimum required output (2*X + Y >= 20)
int: output_per_hour_X = 2;             % Output units per hour of team X
int: output_per_hour_Y = 1;             % Output units per hour of team Y
int: cost_per_hour_X = 8;               % Cost ($) per hour for team X
int: cost_per_hour_Y = 6;               % Cost ($) per hour for team Y

% Variables
var 0..max_total_hours: hours_X;        % Integer hours allocated to team X
var 0..max_total_hours: hours_Y;        % Integer hours allocated to team Y
var 0..(cost_per_hour_X*max_total_hours + cost_per_hour_Y*max_total_hours): total_cost;
% Total cost to minimize

% Constraints
% Total hours budget constraint (X + Y <= 40)
constraint hours_X + hours_Y <= max_total_hours;

% Minimum output requirement constraint (2*X + 1*Y >= 20)
constraint output_per_hour_X * hours_X + output_per_hour_Y * hours_Y >= min_output_units;

% Define total cost based on allocated hours (total_cost = 8*X + 6*Y)
constraint total_cost = cost_per_hour_X * hours_X + cost_per_hour_Y * hours_Y;

% Objective
solve minimize total_cost;