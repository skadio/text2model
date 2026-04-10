% Parameters
int: max_total_hours = 10;                 % Total available hours for activities X and Y
int: learn_coeff_x = 5;                    % Learning objective coefficient for X
int: learn_coeff_y = 6;                    % Learning objective coefficient for Y
int: min_learning = 20;                    % Minimum required combined learning objective
int: resource_per_hour_x = 2;              % Resource units per hour for X
int: resource_per_hour_y = 3;              % Resource units per hour for Y

% Upper bounds for decision variables (bounded by total hours limit)
int: ub_x = max_total_hours;
int: ub_y = max_total_hours;


% Variables
var 0..ub_x: hours_x;                      % Integer hours allocated to activity X
var 0..ub_y: hours_y;                      % Integer hours allocated to activity Y

var 0..(resource_per_hour_x * ub_x + resource_per_hour_y * ub_y): total_resources;
                                           % Total resource usage to minimize (integer)


% Constraints
% --- Hours capacity constraint (schedule limit) ---
constraint
  hours_x + hours_y <= max_total_hours;

% --- Minimum learning objective constraint ---
constraint
  learn_coeff_x * hours_x + learn_coeff_y * hours_y >= min_learning;

% --- Define total resource usage from hours allocated ---
constraint
  total_resources = resource_per_hour_x * hours_x + resource_per_hour_y * hours_y;


% Objective
solve minimize total_resources;