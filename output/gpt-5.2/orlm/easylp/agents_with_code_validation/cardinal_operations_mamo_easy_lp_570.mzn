% Parameters
int: max_total_units = 1000;          % Upper bound on total supported units
int: min_2x_plus_y = 200;             % Minimum required for 2*X + Y
int: max_diff_x_z = 50;               % Maximum allowed |X - Z|
int: min_y_plus_z = 400;              % Minimum required for Y + Z

int: support_x = 500;                 % Support points per unit of type X
int: support_y = 300;                 % Support points per unit of type Y
int: support_z = 700;                 % Support points per unit of type Z

% Variables
var 0..max_total_units: x;            % Allocation to unit type X (integer, nonnegative)
var 0..max_total_units: y;            % Allocation to unit type Y (integer, nonnegative)
var 0..max_total_units: z;            % Allocation to unit type Z (integer, nonnegative)

% Total support points (upper bound derived from max_total_units for each type)
var 0..(support_x*max_total_units + support_y*max_total_units + support_z*max_total_units): total_support;

% Constraints
% Total units capacity (logistical upper bound)
constraint x + y + z <= max_total_units;

% Minimum force requirement: 2*X + Y must be at least the threshold
constraint 2 * x + y >= min_2x_plus_y;

% Balance constraint: X and Z allocations must be within max_diff_x_z
constraint abs(x - z) <= max_diff_x_z;

% Minimum combined allocation for Y and Z
constraint y + z >= min_y_plus_z;

% Define total support points from per-unit support requirements
constraint total_support = support_x * x + support_y * y + support_z * z;

% Objective
solve minimize total_support;