% Parameters
int: min_total_resources = 100;                 % Minimum required combined resources (X + Y)
int: max_weighted_resources = 250;              % Maximum allowed weighted resources (2*X + Y)
int: cost_per_x = 50;                           % Cost per unit resource in department X
int: cost_per_y = 80;                           % Cost per unit resource in department Y

% Variables
var 0..max_weighted_resources: x_resources;     % Resources allocated to department X
var 0..max_weighted_resources: y_resources;     % Resources allocated to department Y
var 0..(cost_per_y * max_weighted_resources): total_cost; % Total cost (upper bound is safe)

% Constraints
% Linear cost accounting
constraint
  total_cost = cost_per_x * x_resources + cost_per_y * y_resources;

% Minimum operating requirement
constraint
  x_resources + y_resources >= min_total_resources;

% Limited availability constraint
constraint
  2 * x_resources + y_resources <= max_weighted_resources;

% Objective
solve minimize total_cost;