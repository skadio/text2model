% Parameters
int: max_units = 150;                 % Maximum total number of units
int: min_strength = 100;              % Minimum required combined strength from 3*X + 4*Y
int: max_diff_zx = 30;                % Maximum allowed absolute difference |Z - X|
int: min_y_over_z = 20;               % Minimum required Y - Z

int: cost_x = 10000;                  % Support points per unit of X
int: cost_y = 2000;                   % Support points per unit of Y
int: cost_z = 500;                    % Support points per unit of Z

% Variables
var 0..max_units: x_units;            % Number of X units
var 0..max_units: y_units;            % Number of Y units
var 0..max_units: z_units;            % Number of Z units

% Upper bound uses max_units * max(costs) to stay safe and avoid overflow concerns
var 0..(max_units * cost_x): total_support_points;  % Total support points (objective)

% Constraints
% Total units must not exceed logistical limit
constraint x_units + y_units + z_units <= max_units;

% Strategic strength requirement: 3*X + 4*Y must be at least the minimum strength
constraint 3 * x_units + 4 * y_units >= min_strength;

% Balance requirement: absolute difference between Z and X must not exceed max_diff_zx
constraint abs(z_units - x_units) <= max_diff_zx;

% Composition requirement: Y must exceed Z by at least min_y_over_z
constraint y_units - z_units >= min_y_over_z;

% Define total support points from unit counts and per-unit costs
constraint total_support_points = cost_x * x_units + cost_y * y_units + cost_z * z_units;

% Objective
solve minimize total_support_points;