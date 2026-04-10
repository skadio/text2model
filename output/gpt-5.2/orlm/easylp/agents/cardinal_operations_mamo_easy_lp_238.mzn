% Parameters
% Total available resources (units)
int: total_resource_cap = 5000;

% Minimum ratio requirements
int: min_x_per_y = 3;   % X >= 3 * Y
int: min_z_per_y = 2;   % Z >= 2 * Y

% Costs per unit resource allocated
int: cost_x = 100;
int: cost_y = 200;
int: cost_z = 150;

% Variables
% Resource allocations (whole units, non-negative, bounded by total cap)
var 0..total_resource_cap: x_units;  % units allocated to crop X
var 0..total_resource_cap: y_units;  % units allocated to crop Y
var 0..total_resource_cap: z_units;  % units allocated to crop Z

% Total cost (bounded using max possible per-unit cost)
var 0..(cost_y * total_resource_cap): total_cost;  % total cost in dollars

% Constraints
% Total resource usage cannot exceed the available capacity
constraint x_units + y_units + z_units <= total_resource_cap;

% Minimum ratio requirements between crops (X and Z relative to Y)
constraint x_units >= min_x_per_y * y_units;
constraint z_units >= min_z_per_y * y_units;

% Define total cost from per-unit costs and allocated units
constraint total_cost = cost_x * x_units + cost_y * y_units + cost_z * z_units;

% Objective
solve minimize total_cost;