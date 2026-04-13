% Parameters
int: max_total_units = 150;                 % Logistical cap on total units X+Y+Z
int: min_strength_requirement = 100;        % Minimum required combined strength
int: strength_coeff_X = 3;                  % Strength contribution coefficient for X
int: strength_coeff_Y = 4;                  % Strength contribution coefficient for Y
int: max_diff_Z_X = 30;                     % |Z - X| must not exceed this
int: min_Y_minus_Z = 20;                    % Y must be at least this many more than Z

int: support_cost_X = 10000;                % Support points per unit of X
int: support_cost_Y = 2000;                 % Support points per unit of Y
int: support_cost_Z = 500;                  % Support points per unit of Z

% Variables
var 0..max_total_units: x_units;            % Number of X units (integer, non-negative)
var 0..max_total_units: y_units;            % Number of Y units (integer, non-negative)
var 0..max_total_units: z_units;            % Number of Z units (integer, non-negative)

var 0..(support_cost_X*max_total_units + support_cost_Y*max_total_units + support_cost_Z*max_total_units):
  total_support_points;                     % Total support points to minimize (bounded)

% Constraints
% Total units logistical cap
constraint
  x_units + y_units + z_units <= max_total_units;

% Minimum combined strength requirement from X and Y
constraint
  strength_coeff_X * x_units + strength_coeff_Y * y_units >= min_strength_requirement;

% Balance constraint: Z and X must be within max_diff_Z_X units of each other
constraint
  abs(z_units - x_units) <= max_diff_Z_X;

% Composition constraint: Y must exceed Z by at least min_Y_minus_Z
constraint
  y_units - z_units >= min_Y_minus_Z;

% Define total support points from unit counts and per-unit support costs
constraint
  total_support_points =
    support_cost_X * x_units + support_cost_Y * y_units + support_cost_Z * z_units;

% Objective
solve minimize total_support_points;