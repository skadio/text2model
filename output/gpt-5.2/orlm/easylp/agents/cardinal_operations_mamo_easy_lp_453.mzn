% Parameters
int: resource_limit = 200;                 % Upper bound for 2*X + Y
int: ecosystem_min = 150;                  % Lower bound for X + 3*Y
int: max_difference = 20;                  % Upper bound for |X - Y|
int: cost_per_unit_X = 100;                % Cost per unit allocated to crop X
int: cost_per_unit_Y = 50;                 % Cost per unit allocated to crop Y

% Variables
var 0..resource_limit: x_units;            % Whole number of resource units allocated to crop X
var 0..resource_limit: y_units;            % Whole number of resource units allocated to crop Y
var 0..(cost_per_unit_X*resource_limit + cost_per_unit_Y*resource_limit): total_cost; % Total cost (bounded)

% Constraints
% Resource capacity constraint: 2*X + Y cannot exceed the resource limit
constraint 2 * x_units + y_units <= resource_limit;

% Ecosystem balance constraint: X + 3*Y must be at least the minimum required
constraint x_units + 3 * y_units >= ecosystem_min;

% Difference constraint: the absolute difference between X and Y cannot exceed max_difference
constraint abs(x_units - y_units) <= max_difference;

% Total cost definition: compute total_cost from x_units and y_units
constraint total_cost = cost_per_unit_X * x_units + cost_per_unit_Y * y_units;

% Objective
solve minimize total_cost;