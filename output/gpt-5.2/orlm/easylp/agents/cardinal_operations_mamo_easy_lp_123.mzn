% Parameters
int: max_total_hours = 10;              % Total hours available (X + Y <= 10)
int: min_learning_score = 20;           % Minimum required learning score (5X + 6Y >= 20)

int: learning_per_hour_X = 5;           % Learning contribution per hour of activity X
int: learning_per_hour_Y = 6;           % Learning contribution per hour of activity Y

int: resource_per_hour_X = 2;           % Resource units used per hour of activity X
int: resource_per_hour_Y = 3;           % Resource units used per hour of activity Y

% Variables
var 0..max_total_hours: hours_X;        % Integer hours allocated to activity X
var 0..max_total_hours: hours_Y;        % Integer hours allocated to activity Y

var 0..(resource_per_hour_X*max_total_hours + resource_per_hour_Y*max_total_hours): total_resource;
                                        % Total resource usage (to be minimized), bounded

% Constraints
% Total hours capacity constraint (scheduling limit)
constraint
  hours_X + hours_Y <= max_total_hours;

% Minimum learning score requirement
constraint
  learning_per_hour_X * hours_X + learning_per_hour_Y * hours_Y >= min_learning_score;

% Define total resource usage from allocated hours
constraint
  total_resource = resource_per_hour_X * hours_X + resource_per_hour_Y * hours_Y;

% Objective
solve minimize total_resource;