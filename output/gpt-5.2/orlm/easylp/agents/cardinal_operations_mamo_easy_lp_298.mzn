% Parameters
int: total_resource_limit = 100;          % Maximum total resources available (X + Y + Z <= 100)
int: min_env_score = 50;                  % Minimum required environmental score (2*Y + Z >= 50)
int: xz_logistics_limit = 80;             % Logistics limit on X and Z combined (X + Z <= 80)

int: cost_X = 2;                          % Cost per unit allocated to initiative X
int: cost_Y = 3;                          % Cost per unit allocated to initiative Y
int: cost_Z = 1;                          % Cost per unit allocated to initiative Z

% Variables
var 0..total_resource_limit: X;           % Integer resources allocated to initiative X
var 0..total_resource_limit: Y;           % Integer resources allocated to initiative Y
var 0..total_resource_limit: Z;           % Integer resources allocated to initiative Z

% Upper bound on total cost (all resources allocated to the most expensive initiative)
var 0..(cost_X*total_resource_limit + cost_Y*total_resource_limit + cost_Z*total_resource_limit): total_cost;

% Constraints
% Total resource budget constraint: X + Y + Z <= total_resource_limit
constraint X + Y + Z <= total_resource_limit;

% Environmental score constraint: 2*Y + Z >= min_env_score
constraint 2 * Y + Z >= min_env_score;

% Logistics constraint on initiatives X and Z: X + Z <= xz_logistics_limit
constraint X + Z <= xz_logistics_limit;

% Total cost definition
constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;