% Parameters
% Total available resources (budget cap in resource units)
int: max_total_resources = 1000;

% Minimum combined resources for channels X and Y
int: min_xy_resources = 200;

% Minimum combined resources for channels Y and 2*Z
int: min_y2z_resources = 300;

% Effectiveness requirement: X must be at least twice Y
int: x_to_y_multiplier = 2;

% Effectiveness requirement: multiplier on Z in the (Y + 2*Z) constraint
int: z_multiplier_in_yz = 2;

% Unit costs (dollars per resource unit)
int: cost_x = 10;
int: cost_y = 15;
int: cost_z = 20;


% Variables
% Integer resource allocations (nonnegative and bounded by total capacity)
var 0..max_total_resources: x_resources; % resources allocated to channel X
var 0..max_total_resources: y_resources; % resources allocated to channel Y
var 0..max_total_resources: z_resources; % resources allocated to channel Z

% Total cost (bounded for linear objective)
var 0..(max_total_resources * max(cost_x, max(cost_y, cost_z))): total_cost; % total spend in dollars


% Constraints
% Resource capacity constraint: total allocated resources cannot exceed the cap
constraint x_resources + y_resources + z_resources <= max_total_resources;

% Channel effectiveness constraint: X must be at least twice Y
constraint x_resources >= x_to_y_multiplier * y_resources;

% Minimum combined allocation for channels X and Y
constraint x_resources + y_resources >= min_xy_resources;

% Minimum combined allocation for channel Y and twice Z
constraint y_resources + z_multiplier_in_yz * z_resources >= min_y2z_resources;

% Total cost linking constraint (linear expression)
constraint total_cost = cost_x * x_resources + cost_y * y_resources + cost_z * z_resources;


% Objective
solve minimize total_cost;