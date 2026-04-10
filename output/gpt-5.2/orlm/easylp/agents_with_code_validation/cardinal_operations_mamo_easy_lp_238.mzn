% Parameters
% Total available resource units (manpower/land/equipment)
int: total_resource_limit = 5000;

% Per-unit costs (in dollars) for each crop
int: cost_X = 100;
int: cost_Y = 200;
int: cost_Z = 150;

% Ratio requirements expressed as multipliers of Y
int: min_X_per_Y = 3;  % X >= 3*Y
int: min_Z_per_Y = 2;  % Z >= 2*Y


% Variables
% Integer resource allocations to each crop (non-negative, bounded by total limit)
var 0..total_resource_limit: x_units; % resources allocated to crop X
var 0..total_resource_limit: y_units; % resources allocated to crop Y
var 0..total_resource_limit: z_units; % resources allocated to crop Z

% Total cost (bounded using max unit cost * total limit)
var 0..(max([cost_X, cost_Y, cost_Z]) * total_resource_limit): total_cost;


% Constraints
% Resource capacity limit (total allocated resources cannot exceed available limit)
constraint x_units + y_units + z_units <= total_resource_limit;

% Ratio requirements relative to Y (ensure required minimum allocations)
constraint x_units >= min_X_per_Y * y_units;  % X >= 3*Y
constraint z_units >= min_Z_per_Y * y_units;  % Z >= 2*Y

% Total cost calculation from per-unit costs and allocated units
constraint total_cost = cost_X * x_units + cost_Y * y_units + cost_Z * z_units;


% Objective
solve minimize total_cost;