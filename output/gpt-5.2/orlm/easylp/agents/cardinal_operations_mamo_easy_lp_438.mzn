% Parameters
% Budget and minimum allocation requirements (units)
int: max_total_units = 200;
int: min_units_x = 50;
int: min_units_y = 30;

% Cost per unit for each department (dollars per unit)
int: cost_per_unit_x = 5000;
int: cost_per_unit_y = 8000;

% Variables
% Units allocated to Department X and Y (must be whole numbers)
var 0..max_total_units: units_x;
var 0..max_total_units: units_y;

% Total expenditure in dollars
var 0..(max_total_units * max(cost_per_unit_x, cost_per_unit_y)): total_cost;

% Constraints
% Allocation feasibility: enforce minimum required units for each department
constraint units_x >= min_units_x;
constraint units_y >= min_units_y;

% Total budget in units: combined allocation cannot exceed the maximum total units
constraint units_x + units_y <= max_total_units;

% Total cost definition: compute expenditure from unit allocations and per-unit costs
constraint total_cost = units_x * cost_per_unit_x + units_y * cost_per_unit_y;

% Objective
solve minimize total_cost;