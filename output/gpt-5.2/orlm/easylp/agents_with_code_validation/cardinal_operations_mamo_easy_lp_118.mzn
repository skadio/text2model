% Parameters
int: coefX_max = 2;                 % Coefficient for X in the upper resource constraint
int: coefY_max = 3;                 % Coefficient for Y in the upper resource constraint
int: max_resource_units = 50;       % Upper bound on total weighted resources

int: min_combined_units = 10;       % Minimum combined allocation X + Y
int: max_diff_units = 20;           % Maximum allowed absolute difference |X - Y|

int: cost_per_unit_X = 100;         % Cost per unit for package X
int: cost_per_unit_Y = 200;         % Cost per unit for package Y

% Variables
var 0..max_resource_units: x_units; % Integer units allocated to package X (nonnegative, bounded)
var 0..max_resource_units: y_units; % Integer units allocated to package Y (nonnegative, bounded)

var 0..(cost_per_unit_Y * max_resource_units): total_cost; % Total cost (bounded)

% Constraints
% --- Resource capacity constraint (weighted sum upper bound) ---
constraint
  coefX_max * x_units + coefY_max * y_units <= max_resource_units;

% --- Minimum service/allocation threshold (combined units lower bound) ---
constraint
  x_units + y_units >= min_combined_units;

% --- Logistical balance constraint (difference between packages bounded) ---
constraint
  abs(x_units - y_units) <= max_diff_units;

% --- Cost aggregation constraint (define total cost from allocations) ---
constraint
  total_cost = cost_per_unit_X * x_units + cost_per_unit_Y * y_units;

% Objective
solve minimize total_cost;