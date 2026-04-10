% Parameters
% Budget and cost data (embedded directly in the model)
int: total_budget_units = 200;        % Maximum combined allocation units for X and Y
int: min_units_x = 50;               % Minimum allocation units for Department X
int: min_units_y = 30;               % Minimum allocation units for Department Y
int: cost_per_unit_x = 5000;         % Cost in dollars per unit for Department X
int: cost_per_unit_y = 8000;         % Cost in dollars per unit for Department Y

% Variables
% Integer allocation units (whole numbers) within feasible bounds
var min_units_x..total_budget_units: units_x;    % Allocation units for Department X
var min_units_y..total_budget_units: units_y;    % Allocation units for Department Y

% Total expenditure in dollars (upper bound uses worst-case cost per unit)
var 0..(total_budget_units * max(cost_per_unit_x, cost_per_unit_y)): total_cost;

% Constraints
% Budget feasibility: combined allocation units cannot exceed total available units
constraint units_x + units_y <= total_budget_units;

% Total cost calculation: compute expenditure from per-unit costs
constraint total_cost = units_x * cost_per_unit_x + units_y * cost_per_unit_y;

% Objective
solve minimize total_cost;