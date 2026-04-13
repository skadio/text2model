% Parameters
int: total_resource_cap = 200;              % Maximum total resources available
int: min_requirement = 100;                 % Minimum required for 2*X + Y
int: max_difference = 50;                   % Maximum allowed |X - Y|
int: max_x = 150;                           % Upper bound on allocation for project X
int: max_y = 100;                           % Upper bound on allocation for project Y
int: cost_per_x = 5000;                     % Cost per unit allocated to X (dollars)
int: cost_per_y = 3000;                     % Cost per unit allocated to Y (dollars)

% Variables
var 0..max_x: x;                            % Resource units allocated to project X
var 0..max_y: y;                            % Resource units allocated to project Y
var 0..(cost_per_x*max_x + cost_per_y*max_y): total_cost;  % Total cost (dollars)

% Constraints
% Link total_cost to allocations (linear cost accounting)
constraint total_cost = cost_per_x * x + cost_per_y * y;

% Total resource capacity constraint (budget/resource cap)
constraint x + y <= total_resource_cap;

% Minimum combined requirement for projects (2*X + Y at least min_requirement)
constraint 2 * x + y >= min_requirement;

% Balance constraint: absolute difference between allocations must be within max_difference
constraint abs(x - y) <= max_difference;

% Objective
solve minimize total_cost;