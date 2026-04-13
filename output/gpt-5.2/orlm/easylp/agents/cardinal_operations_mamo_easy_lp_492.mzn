% Parameters
% Upper bound on total supported units
int: max_units = 10000;

% Minimum combined strength requirement: 2*X + Y >= min_strength
int: min_strength = 7000;

% Balance constraint limit: X - 2*Y <= max_imbalance
int: max_imbalance = 2000;

% Support points per unit
int: support_per_x = 5000;
int: support_per_y = 3000;

% Variables
% Number of units of type X and Y (whole numbers, non-negative, and cannot exceed max_units)
var 0..max_units: x_units;
var 0..max_units: y_units;

% Total support points to minimize (bounded above by allocating all max_units to X)
var 0..(support_per_x * max_units): total_support;

% Constraints
% Total units capacity constraint: X + Y <= max_units
constraint x_units + y_units <= max_units;

% Minimum combined strength requirement: 2*X + Y >= min_strength
constraint 2 * x_units + y_units >= min_strength;

% Force balance constraint: X - 2*Y <= max_imbalance
constraint x_units - 2 * y_units <= max_imbalance;

% Define total support points from unit allocations
constraint total_support = support_per_x * x_units + support_per_y * y_units;

% Objective
solve minimize total_support;