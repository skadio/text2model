% Parameters
int: max_total_units = 20;          % Maximum total resource units across X, Y, Z
int: min_feasibility = 5;           % Minimum required for 2*X + Y
int: max_diff_yz = 10;              % Maximum allowed difference Y - Z
int: cost_x = 100;                  % Cost per unit for task X
int: cost_y = 200;                  % Cost per unit for task Y
int: cost_z = 150;                  % Cost per unit for task Z

% Variables
var 0..max_total_units: X;          % Resource units assigned to task X (design)
var 0..max_total_units: Y;          % Resource units assigned to task Y (construction)
var 0..max_total_units: Z;          % Resource units assigned to task Z (inspection)

% Upper bound: max units * maximum unit cost
var 0..(max_total_units * max(cost_x, max(cost_y, cost_z))): total_cost; % Total cost (in dollars)

% Constraints
% Resource capacity constraint: total units across all tasks must not exceed the maximum
constraint X + Y + Z <= max_total_units;

% Feasibility constraint: ensure sufficient combined allocation for design and construction
constraint 2 * X + Y >= min_feasibility;

% Quality control constraint: construction allocation cannot exceed inspection by more than the limit
constraint Y - Z <= max_diff_yz;

% Cost definition constraint: compute total cost from per-unit costs and allocated units
constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;