% Parameters
int: total_resource_limit = 5000;          % Total resources available (budget constraint)
int: min_x_to_y_ratio = 2;                 % X must be at least this many times Y
int: service_level_min = 1000;             % Minimum required service level
int: service_x_coeff = 2;                  % Service contribution coefficient for X
int: service_y_coeff = 1;                  % Service contribution coefficient for Y
int: cost_per_unit_x = 4;                  % Cost per unit allocated to X
int: cost_per_unit_y = 3;                  % Cost per unit allocated to Y

% Variables
var 0..total_resource_limit: x;            % Integer units allocated to distribution center X
var 0..total_resource_limit: y;            % Integer units allocated to distribution center Y
var 0..(cost_per_unit_x*total_resource_limit + cost_per_unit_y*total_resource_limit): total_cost;
                                           % Total cost to minimize

% Constraints
% Resource budget limit: total allocated units cannot exceed available resources
constraint x + y <= total_resource_limit;

% Balance requirement: allocation to X must be at least min_x_to_y_ratio times allocation to Y
constraint x >= min_x_to_y_ratio * y;

% Service level requirement: combined service contribution must meet minimum threshold
constraint service_x_coeff * x + service_y_coeff * y >= service_level_min;

% Total cost definition: link total_cost to allocations and unit costs
constraint total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Objective
solve minimize total_cost;