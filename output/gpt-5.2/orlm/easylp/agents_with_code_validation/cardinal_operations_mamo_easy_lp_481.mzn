% Parameters
int: total_resources_max = 500;          % Maximum combined resources for initiatives X and Y
int: x_minus_y_min = 100;                % Minimum required difference: X must be at least this much more than Y
int: x_max = 350;                        % Maximum resources allowed for initiative X
int: cost_per_unit_x = 20;               % Cost per unit of resource for initiative X
int: cost_per_unit_y = 10;               % Cost per unit of resource for initiative Y

% Variables
var 0..x_max: x_resources;               % Whole-number resources allocated to initiative X
var 0..total_resources_max: y_resources; % Whole-number resources allocated to initiative Y
var 0..(cost_per_unit_x*x_max + cost_per_unit_y*total_resources_max): total_cost; % Total cost (bounded)

% Constraints
% Resource capacity: total allocation cannot exceed the overall budgeted resources
constraint
  x_resources + y_resources <= total_resources_max;

% Minimum difference requirement: X must receive at least 100 more units than Y
constraint
  x_resources - y_resources >= x_minus_y_min;

% Total cost definition from per-unit costs
constraint
  total_cost = cost_per_unit_x * x_resources + cost_per_unit_y * y_resources;

% Objective
solve minimize total_cost;