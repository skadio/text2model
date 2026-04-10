% Parameters
% Total available resource units
int: total_capacity = 100;

% Minimum required units for each program
int: min_x = 10;
int: min_y = 20;
int: min_z = 15;

% Cost per unit (in dollars) for each program
int: cost_x = 30;
int: cost_y = 20;
int: cost_z = 50;


% Variables
% Integer resource units allocated to programs X, Y, and Z
var min_x..total_capacity: x_units;
var min_y..total_capacity: y_units;
var min_z..total_capacity: z_units;

% Total cost (bounded using capacity and max unit cost)
var 0..(total_capacity * max([cost_x, cost_y, cost_z])): total_cost;


% Constraints
% Capacity constraint: total allocated units across all programs cannot exceed total capacity
constraint x_units + y_units + z_units <= total_capacity;

% Minimum requirement constraints (redundant due to variable domains, kept for clarity/robustness)
constraint x_units >= min_x;
constraint y_units >= min_y;
constraint z_units >= min_z;

% Total cost definition: compute total cost from unit allocations and per-unit costs
constraint total_cost = cost_x * x_units + cost_y * y_units + cost_z * z_units;


% Objective
solve minimize total_cost;