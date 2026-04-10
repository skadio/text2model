% Parameters
int: max_total_units = 1000;        % Capacity limit: X + Y + Z <= 1000
int: min_demand_units = 300;        % Demand constraint: 2*X + Y >= 300
int: max_resource_units = 600;      % Resource constraint: X + 3*Z <= 600

int: cost_X = 50;                  % Unit cost of product X
int: cost_Y = 30;                  % Unit cost of product Y
int: cost_Z = 20;                  % Unit cost of product Z

% Variables
var 0..max_total_units: x_units;    % Units produced of product X (integer, nonnegative)
var 0..max_total_units: y_units;    % Units produced of product Y (integer, nonnegative)
var 0..max_total_units: z_units;    % Units produced of product Z (integer, nonnegative)

var 0..(cost_X*max_total_units + cost_Y*max_total_units + cost_Z*max_total_units): total_cost;
% Total cost to minimize (bounded for solver support)

% Constraints
% Capacity constraint: total production cannot exceed capacity
constraint
  x_units + y_units + z_units <= max_total_units;

% Demand constraint: market demand requirement
constraint
  2 * x_units + y_units >= min_demand_units;

% Resource/operational constraint: limit on X and Z combination
constraint
  x_units + 3 * z_units <= max_resource_units;

% Total cost definition
constraint
  total_cost = cost_X * x_units + cost_Y * y_units + cost_Z * z_units;

% Objective
solve minimize total_cost;

% (Optional) Output for inspection
output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "z_units=", show(z_units), "\n",
  "total_cost=", show(total_cost), "\n"
];