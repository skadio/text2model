% Parameters
int: total_resources = 100;
int: min_ratio_X_to_Y = 2;          % X >= 2*Y
int: min_diff_Z_over_X = 10;        % Z >= X + 10
int: cost_X = 10;
int: cost_Y = 20;
int: cost_Z = 30;

% Variables
var 0..total_resources: X;
var 0..total_resources: Y;
var 0..total_resources: Z;
var 0..(cost_X*total_resources + cost_Y*total_resources + cost_Z*total_resources): total_cost;

% Constraints
constraint X + Y + Z <= total_resources;
constraint X >= min_ratio_X_to_Y * Y;
constraint Z >= X + min_diff_Z_over_X;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;