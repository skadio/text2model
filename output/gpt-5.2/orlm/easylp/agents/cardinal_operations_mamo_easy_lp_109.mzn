% Parameters
int: min_total_time = 15;              % Minimum total training time (hours)
int: max_weighted_time = 40;           % Maximum allowed value of (2*x + y) (hours)
int: cost_per_hour_x = 20;             % Cost per hour for exercise X ($/hour)
int: cost_per_hour_y = 30;             % Cost per hour for exercise Y ($/hour)
int: weight_x = 2;                     % Coefficient of x in weighted time constraint
int: weight_y = 1;                     % Coefficient of y in weighted time constraint

% Variables
var 0..max_weighted_time: x;           % Whole hours assigned to exercise X
var 0..max_weighted_time: y;           % Whole hours assigned to exercise Y
var 0..(cost_per_hour_x * max_weighted_time + cost_per_hour_y * max_weighted_time): total_cost;
                                       % Total cost in dollars (integer)

% Constraints

% Training time requirement: ensure sufficient total conditioning time
constraint x + y >= min_total_time;

% Facility/weighted time limit: respect maximum allowed (weight_x*x + weight_y*y)
constraint weight_x * x + weight_y * y <= max_weighted_time;

% Cost calculation: link total_cost to the hours assigned and per-hour costs
constraint total_cost = cost_per_hour_x * x + cost_per_hour_y * y;

% Objective
solve minimize total_cost;