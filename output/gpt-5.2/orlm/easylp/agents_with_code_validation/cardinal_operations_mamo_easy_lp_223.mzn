% Parameters
int: total_resource_limit = 100;              % Total available resource units across X,Y,Z
int: min_2x_plus_y = 50;                      % Minimum required for 2*X + Y
int: max_x_plus_z = 70;                       % Maximum allowed for X + Z

int: cost_x = 50;                             % Cost per unit allocated to project X
int: cost_y = 30;                             % Cost per unit allocated to project Y
int: cost_z = 20;                             % Cost per unit allocated to project Z

% Variables
var 0..total_resource_limit: x;               % Resource units allocated to project X
var 0..total_resource_limit: y;               % Resource units allocated to project Y
var 0..total_resource_limit: z;               % Resource units allocated to project Z

var 0..(cost_x*total_resource_limit + cost_y*total_resource_limit + cost_z*total_resource_limit): total_cost;
                                              % Total cost to minimize

% Constraints
% Total resource budget across all projects
constraint x + y + z <= total_resource_limit;

% Strategic requirement: 2*X + Y must meet minimum threshold
constraint 2 * x + y >= min_2x_plus_y;

% Capacity/feasibility limit: X + Z must not exceed maximum
constraint x + z <= max_x_plus_z;

% Define total cost from allocations (integer arithmetic)
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;