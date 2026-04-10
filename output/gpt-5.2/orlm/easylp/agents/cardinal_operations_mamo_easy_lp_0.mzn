% Parameters
int: total_budget_units = 1000;        % Total available resource units for both projects
int: min_excess_x_over_y = 200;        % Minimum required excess of X over Y (X >= Y + 200)
int: cost_per_unit_x = 50;             % Cost per unit allocated to project X (dollars)
int: cost_per_unit_y = 30;             % Cost per unit allocated to project Y (dollars)
int: max_units_x = 700;                % Operational maximum units for project X
int: max_units_y = 500;                % Operational maximum units for project Y

% Variables
var 0..max_units_x: x_units;           % Integer units allocated to project X
var 0..max_units_y: y_units;           % Integer units allocated to project Y
var 0..(cost_per_unit_x*max_units_x + cost_per_unit_y*max_units_y): total_cost;
                                       % Total cost in dollars (bounded by max possible cost)

% Constraints
% Budget constraint: total allocated resource units cannot exceed available budget
constraint x_units + y_units <= total_budget_units;

% Success requirement: project X must exceed project Y by at least the specified minimum
constraint x_units >= y_units + min_excess_x_over_y;

% Cost definition: total cost equals sum of per-unit costs for both projects
constraint total_cost = cost_per_unit_x * x_units + cost_per_unit_y * y_units;

% Objective
solve minimize total_cost;