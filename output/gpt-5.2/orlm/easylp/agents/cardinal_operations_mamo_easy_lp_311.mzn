% Parameters
int: max_total_units = 1000;          % Maximum total number of units supported
int: min_strength_req = 200;          % Minimum required strength for (2*X + 1*Y)
int: min_xz_units = 300;              % Minimum required units for (X + Z)

int: cost_X = 300;                    % Resource points per unit of X
int: cost_Y = 500;                    % Resource points per unit of Y
int: cost_Z = 700;                    % Resource points per unit of Z


% Variables
var 0..max_total_units: units_X;      % Number of units of type X (integer, non-negative)
var 0..max_total_units: units_Y;      % Number of units of type Y (integer, non-negative)
var 0..max_total_units: units_Z;      % Number of units of type Z (integer, non-negative)

var 0..(max_total_units * max([cost_X, cost_Y, cost_Z])): total_resource_points;
                                      % Total resource points (bounded for linear objective)


% Constraints
%--- Total units capacity constraint (logistical support limit)
constraint
  units_X + units_Y + units_Z <= max_total_units;

%--- Minimum strength requirement: 2*X + 1*Y must reach required threshold
constraint
  2 * units_X + units_Y >= min_strength_req;

%--- Minimum combined units for groups X and Z
constraint
  units_X + units_Z >= min_xz_units;

%--- Define total resource points from per-unit costs
constraint
  total_resource_points =
    cost_X * units_X + cost_Y * units_Y + cost_Z * units_Z;


% Objective
solve minimize total_resource_points;