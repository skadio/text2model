% Parameters
int: capacity = 500;                 % Maximum total items that can be stored

int: min_x = 100;                    % Minimum required items of category X
int: min_y = 80;                     % Minimum required items of category Y
int: min_z = 120;                    % Minimum required items of category Z

int: cost_x = 5;                     % Cost per item of category X
int: cost_y = 4;                     % Cost per item of category Y
int: cost_z = 6;                     % Cost per item of category Z

% Variables
var min_x..capacity: x;              % Items stocked of category X
var min_y..capacity: y;              % Items stocked of category Y
var min_z..capacity: z;              % Items stocked of category Z

% Upper bound: all items at the maximum unit cost
int: max_cost = max([cost_x, cost_y, cost_z]);
var 0..(capacity * max_cost): total_cost; % Total cost (dollars)

% Constraints
% Capacity / space constraint: total items stored cannot exceed available capacity
constraint
  x + y + z <= capacity;

% Total cost definition: compute total_cost from per-item costs and quantities
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;