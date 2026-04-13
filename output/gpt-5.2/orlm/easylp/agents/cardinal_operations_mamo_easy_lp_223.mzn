% Parameters
int: total_resource_limit = 100;          % Total available resources across X, Y, Z
int: min_2X_plus_Y = 50;                  % Minimum required value for 2*X + Y
int: max_X_plus_Z = 70;                   % Maximum allowed value for X + Z

int: cost_X = 50;                         % Cost per unit for project X
int: cost_Y = 30;                         % Cost per unit for project Y
int: cost_Z = 20;                         % Cost per unit for project Z


% Variables
var 0..total_resource_limit: x;           % Integer units allocated to project X
var 0..total_resource_limit: y;           % Integer units allocated to project Y
var 0..total_resource_limit: z;           % Integer units allocated to project Z

% Total cost (upper bound: all resources spent in all projects at their unit costs)
var 0..(cost_X*total_resource_limit + cost_Y*total_resource_limit + cost_Z*total_resource_limit): total_cost;


% Constraints
% Resource capacity constraint: total allocation cannot exceed available resources
constraint x + y + z <= total_resource_limit;

% Strategic requirement constraint: ensure 2*X + Y meets the minimum threshold
constraint 2*x + y >= min_2X_plus_Y;

% Strategic limit constraint: X + Z must not exceed the specified maximum
constraint x + z <= max_X_plus_Z;

% Total cost definition: compute total_cost from per-unit costs and allocations
constraint total_cost = cost_X*x + cost_Y*y + cost_Z*z;


% Objective
solve minimize total_cost;