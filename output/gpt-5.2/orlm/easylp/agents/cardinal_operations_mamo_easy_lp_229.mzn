% Parameters
int: total_budget_units = 1000;          % Maximum total resource units available
int: min_x_units = 200;                 % Minimum required units for area X
int: min_y_units = 150;                 % Minimum required units for area Y
int: min_z_units = 250;                 % Minimum required units for area Z

int: cost_x = 10;                       % Cost per unit in area X (dollars)
int: cost_y = 15;                       % Cost per unit in area Y (dollars)
int: cost_z = 20;                       % Cost per unit in area Z (dollars)

% Variables
var min_x_units..total_budget_units: x; % Units allocated to area X
var min_y_units..total_budget_units: y; % Units allocated to area Y
var min_z_units..total_budget_units: z; % Units allocated to area Z

% Upper bound uses max cost per unit times the maximum possible units
var 0..(total_budget_units * max([cost_x, cost_y, cost_z])): total_cost; % Total cost (dollars)

% Constraints
% Budget constraint: total allocated units across X, Y, Z cannot exceed available budget
constraint x + y + z <= total_budget_units;

% Total cost definition: compute total_cost from per-unit costs and allocations
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;