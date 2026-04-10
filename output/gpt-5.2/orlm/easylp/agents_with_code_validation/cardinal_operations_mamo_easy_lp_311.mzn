% Parameters
int: max_units = 1000;                 % Total units support limit
int: min_strength_req = 200;           % Minimum required combined strength for 2*X + 1*Y
int: min_xz_units = 300;               % Minimum required units for X + Z

int: cost_x = 300;                     % Resource points per unit of X
int: cost_y = 500;                     % Resource points per unit of Y
int: cost_z = 700;                     % Resource points per unit of Z

% Variables
var 0..max_units: units_x;             % Number of X units (integer, nonnegative)
var 0..max_units: units_y;             % Number of Y units (integer, nonnegative)
var 0..max_units: units_z;             % Number of Z units (integer, nonnegative)

% Upper bound: if all max_units were of the most expensive type
var 0..(max_units * max(cost_x, max(cost_y, cost_z))): total_resource_points;

% Constraints
% --- Unit availability / logistics cap ---
constraint units_x + units_y + units_z <= max_units;

% --- Strategic requirement: combined strength of 2*X + 1*Y ---
constraint 2 * units_x + units_y >= min_strength_req;

% --- Deployment requirement: ensure enough units in groups X and Z ---
constraint units_x + units_z >= min_xz_units;

% --- Accounting: total resource points equals weighted sum of units ---
constraint total_resource_points = cost_x * units_x + cost_y * units_y + cost_z * units_z;

% Objective
solve minimize total_resource_points;