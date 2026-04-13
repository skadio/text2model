% Parameters
int: total_resource_limit = 1000;         % Maximum total allocation across X, Y, Z
int: min_extra_over_2y_for_x = 200;       % X must be at least (2*Y + 200)
int: yz_combined_limit = 800;             % Maximum combined allocation for Y and Z

int: cost_x = 500;                        % Cost per unit allocated to division X (infantry)
int: cost_y = 700;                        % Cost per unit allocated to division Y (artillery)
int: cost_z = 300;                        % Cost per unit allocated to division Z (air support)

% Variables
var 0..total_resource_limit: x;           % Units allocated to division X (integer, nonnegative)
var 0..total_resource_limit: y;           % Units allocated to division Y (integer, nonnegative)
var 0..total_resource_limit: z;           % Units allocated to division Z (integer, nonnegative)

% Total cost (upper bound from allocating all 1000 to each division individually, summed)
var 0..(cost_x*total_resource_limit + cost_y*total_resource_limit + cost_z*total_resource_limit): total_cost;

% Constraints
% Total allocation cannot exceed the overall logistical limit
constraint x + y + z <= total_resource_limit;

% Strategic requirement: X must be at least 200 more than twice Y
constraint x >= 2 * y + min_extra_over_2y_for_x;

% Balanced force structure: combined allocation to Y and Z cannot exceed the given limit
constraint y + z <= yz_combined_limit;

% Define total cost from per-unit costs and allocations
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;