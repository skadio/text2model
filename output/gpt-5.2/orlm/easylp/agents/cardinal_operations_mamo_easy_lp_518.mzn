% Parameters
int: total_vehicles_limit = 1000;          % Maximum total vehicles available
int: min_diff_XY = 200;                    % Route X must have at least this many more vehicles than Y
int: max_abs_diff_YZ = 150;                % Absolute difference between Y and Z cannot exceed this

int: cost_per_vehicle_X = 10;              % Operating cost per vehicle on route X
int: cost_per_vehicle_Y = 20;              % Operating cost per vehicle on route Y
int: cost_per_vehicle_Z = 30;              % Operating cost per vehicle on route Z

int: cap_X = 500;                          % Maximum capacity for route X
int: cap_Y = 300;                          % Maximum capacity for route Y
int: cap_Z = 200;                          % Maximum capacity for route Z

% Variables
var 0..cap_X: vehicles_X;                  % Number of vehicles assigned to route X
var 0..cap_Y: vehicles_Y;                  % Number of vehicles assigned to route Y
var 0..cap_Z: vehicles_Z;                  % Number of vehicles assigned to route Z

var 0..(cost_per_vehicle_X*cap_X + cost_per_vehicle_Y*cap_Y + cost_per_vehicle_Z*cap_Z): total_cost;
                                            % Total operating cost (bounded by max possible with caps)

% Constraints

% Total vehicles availability constraint
constraint
  vehicles_X + vehicles_Y + vehicles_Z <= total_vehicles_limit;

% Minimum difference constraint between routes X and Y (X at least min_diff_XY more than Y)
constraint
  vehicles_X - vehicles_Y >= min_diff_XY;

% Balance constraint between routes Y and Z (absolute difference bounded)
constraint
  abs(vehicles_Y - vehicles_Z) <= max_abs_diff_YZ;

% Total cost definition constraint
constraint
  total_cost =
    cost_per_vehicle_X * vehicles_X +
    cost_per_vehicle_Y * vehicles_Y +
    cost_per_vehicle_Z * vehicles_Z;

% Objective
solve minimize total_cost;