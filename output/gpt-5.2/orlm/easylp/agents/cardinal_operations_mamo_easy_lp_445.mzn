% Parameters
int: total_resource_limit = 2000;        % Maximum combined resources for X and Y
int: min_diff_2x_minus_y = 500;          % Minimum required value of (2*X - Y)
int: max_diff_x_minus_2y = 1000;         % Maximum allowed value of (X - 2*Y)
int: max_x = 1500;                       % Upper bound on resources for project X
int: max_y = 1000;                       % Upper bound on resources for project Y
int: cost_x = 5;                         % Cost per unit for project X
int: cost_y = 3;                         % Cost per unit for project Y

% Variables
var 0..max_x: x;                         % Integer resource allocation to project X
var 0..max_y: y;                         % Integer resource allocation to project Y
var 0..(cost_x*max_x + cost_y*max_y): total_cost;  % Total cost to minimize

% Constraints
% Total cost definition
constraint total_cost = cost_x * x + cost_y * y;

% Combined resource limit for both projects
constraint x + y <= total_resource_limit;

% Balance requirement: (2*X - Y) must be at least the minimum difference
constraint 2 * x - y >= min_diff_2x_minus_y;

% Balance requirement: (X - 2*Y) must not exceed the maximum difference
constraint x - 2 * y <= max_diff_x_minus_2y;

% Objective
solve minimize total_cost;