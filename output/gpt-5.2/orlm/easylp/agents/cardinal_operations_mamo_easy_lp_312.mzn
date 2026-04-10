% Parameters
int: total_resource_limit = 1000;          % Total allocation across X,Y,Z cannot exceed this
int: yz_combined_limit = 800;              % Combined allocation for Y and Z cannot exceed this

int: cost_x = 500;                         % Cost per unit allocated to division X (infantry)
int: cost_y = 700;                         % Cost per unit allocated to division Y (artillery)
int: cost_z = 300;                         % Cost per unit allocated to division Z (air support)

int: x_offset = 200;                       % X must be at least this much more than twice Y
int: y_multiplier = 2;                     % Multiplier for Y in the constraint involving X

% Variables
var 0..total_resource_limit: x;            % Allocation to division X (integer units)
var 0..total_resource_limit: y;            % Allocation to division Y (integer units)
var 0..total_resource_limit: z;            % Allocation to division Z (integer units)

var 0..(cost_x*total_resource_limit + cost_y*total_resource_limit + cost_z*total_resource_limit): total_cost;
                                           % Total cost (upper bound for safety)

% Constraints
% Total resource usage must not exceed the overall logistical limit
constraint x + y + z <= total_resource_limit;

% Strategic requirement: X must be at least (2*Y + 200)
constraint x >= y_multiplier * y + x_offset;

% Balanced force structure: combined allocation for Y and Z cannot exceed the given limit
constraint y + z <= yz_combined_limit;

% Define total cost from per-unit costs and allocations
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;