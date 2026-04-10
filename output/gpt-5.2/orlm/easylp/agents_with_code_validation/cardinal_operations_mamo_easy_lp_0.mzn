% Parameters
int: total_budget_units = 1000;        % Maximum total units allocated to X and Y
int: min_excess_X_over_Y = 200;        % Minimum required excess of X over Y (X - Y >= 200)
int: cost_per_unit_X = 50;             % Cost per unit allocated to project X (dollars)
int: cost_per_unit_Y = 30;             % Cost per unit allocated to project Y (dollars)
int: max_units_X = 700;                % Operational maximum units for project X
int: max_units_Y = 500;                % Operational maximum units for project Y

% Variables
var 0..max_units_X: x_units;           % Units allocated to project X (integer)
var 0..max_units_Y: y_units;           % Units allocated to project Y (integer)
var 0..(cost_per_unit_X * max_units_X + cost_per_unit_Y * max_units_Y): total_cost; % Total cost (dollars)

% Constraints
% Budget constraint: total allocated units cannot exceed overall budget
constraint x_units + y_units <= total_budget_units;

% Project success constraint: X must exceed Y by at least the required minimum
constraint x_units - y_units >= min_excess_X_over_Y;

% Cost definition: total cost is linear combination of allocations and unit costs
constraint total_cost = cost_per_unit_X * x_units + cost_per_unit_Y * y_units;

% Objective
solve minimize total_cost;