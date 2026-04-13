% Parameters
int: max_resource_limit = 200;          % Upper bound for 2*X + Y
int: min_ecosystem_requirement = 150;   % Lower bound for X + 3*Y
int: max_difference = 20;              % Upper bound for |X - Y|
int: cost_per_unit_X = 100;            % Cost per unit of resource for crop X
int: cost_per_unit_Y = 50;             % Cost per unit of resource for crop Y

% Variables
var 0..max_resource_limit: x;          % Whole units of resource allocated to crop X (non-negative)
var 0..max_resource_limit: y;          % Whole units of resource allocated to crop Y (non-negative)

% Total cost (bounded by maximum possible cost given x,y bounds)
var 0..(cost_per_unit_X*max_resource_limit + cost_per_unit_Y*max_resource_limit): total_cost;

% Constraints
% Resource limit: twice crop X plus crop Y cannot exceed the maximum resource limit
constraint 2 * x + y <= max_resource_limit;

% Ecosystem requirement: crop X plus three times crop Y must be at least the minimum requirement
constraint x + 3 * y >= min_ecosystem_requirement;

% Difference bound: the absolute difference between crop X and crop Y cannot exceed max_difference
constraint abs(x - y) <= max_difference;

% Total cost definition: link total_cost to decision variables and per-unit costs
constraint total_cost = cost_per_unit_X * x + cost_per_unit_Y * y;

% Objective
solve minimize total_cost;