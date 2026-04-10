% Parameters
% Maximum total number of units supported
int: max_units = 1000;

% Minimum requirement for 2*X + Y
int: min_2x_plus_y = 200;

% Maximum allowed absolute difference between X and Z
int: max_diff_x_z = 50;

% Minimum requirement for Y + Z
int: min_y_plus_z = 400;

% Support points per unit type
int: support_x = 500;
int: support_y = 300;
int: support_z = 700;

% Variables
% Allocations of unit types (whole numbers, non-negative, bounded by max_units)
var 0..max_units: x_units;
var 0..max_units: y_units;
var 0..max_units: z_units;

% Total support points to minimize (bounded for safety in linear expressions)
var 0..(max_units * max(support_x, max(support_y, support_z))): total_support_points;

% Constraints
% Total supported units limit
constraint x_units + y_units + z_units <= max_units;

% Minimum requirement: 2*X + Y >= threshold
constraint 2 * x_units + y_units >= min_2x_plus_y;

% Maximum absolute difference between X and Z
constraint abs(x_units - z_units) <= max_diff_x_z;

% Minimum requirement: Y + Z >= threshold
constraint y_units + z_units >= min_y_plus_z;

% Define total support points from allocations (linear aggregation)
constraint total_support_points =
  support_x * x_units + support_y * y_units + support_z * z_units;

% Objective
solve minimize total_support_points;