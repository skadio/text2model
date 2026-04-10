% Parameters
int: total_resources = 100;                 % Maximum total resources available
int: min_x_to_y_ratio = 2;                  % X must be at least this multiple of Y
int: min_z_minus_x = 10;                    % Z must be at least this many units more than X

int: cost_x = 10;                           % Cost per unit for project X
int: cost_y = 20;                           % Cost per unit for project Y
int: cost_z = 30;                           % Cost per unit for project Z

% Variables
var 0..total_resources: x;                  % Integer resources allocated to project X
var 0..total_resources: y;                  % Integer resources allocated to project Y
var 0..total_resources: z;                  % Integer resources allocated to project Z

% Upper bound: worst case if all 100 units were (hypothetically) charged at all three rates
var 0..(cost_x*total_resources + cost_y*total_resources + cost_z*total_resources): total_cost;

% Constraints
% Resource capacity constraint: total allocation cannot exceed available resources
constraint x + y + z <= total_resources;

% Allocation ratio constraint: X must be at least min_x_to_y_ratio times Y
constraint x >= min_x_to_y_ratio * y;

% Difference constraint: Z must be at least min_z_minus_x units more than X
constraint z >= x + min_z_minus_x;

% Total cost definition: compute cost from allocations and per-unit costs
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;