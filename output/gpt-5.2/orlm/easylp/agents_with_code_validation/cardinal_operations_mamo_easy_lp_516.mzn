% Parameters
int: total_capacity = 2000;                 % Maximum total resources across all routes
int: min_diff_X_vs_2Y = 1000;               % Minimum difference between X and 2*Y
int: min_diff_Z_vs_Y = 500;                 % Minimum difference between Z and Y

int: cost_X = 3;                            % Cost per unit on route X
int: cost_Y = 2;                            % Cost per unit on route Y
int: cost_Z = 1;                            % Cost per unit on route Z

% Variables
var 0..total_capacity: x;                   % Allocation to route X (non-negative integer)
var 0..total_capacity: y;                   % Allocation to route Y (non-negative integer)
var 0..total_capacity: z;                   % Allocation to route Z (non-negative integer)

% Upper bound: worst case is allocating full capacity to each (loose but safe bound)
var 0..(cost_X*total_capacity + cost_Y*total_capacity + cost_Z*total_capacity): total_cost;

% Constraints
% Capacity constraint: total resources allocated across all routes cannot exceed capacity
constraint x + y + z <= total_capacity;

% Minimum difference constraint between route X and twice route Y (absolute difference)
constraint abs(x - 2 * y) >= min_diff_X_vs_2Y;

% Minimum difference constraint between route Z and route Y (absolute difference)
constraint abs(z - y) >= min_diff_Z_vs_Y;

% Total cost definition based on per-unit costs
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;