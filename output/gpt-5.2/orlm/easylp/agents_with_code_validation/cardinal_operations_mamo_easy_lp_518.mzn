% Parameters
int: total_vehicles_limit = 1000;          % Total available vehicles
int: min_diff_XY = 200;                    % X must have at least this many more vehicles than Y
int: max_abs_diff_YZ = 150;                % |Y - Z| cannot exceed this value

int: cost_X = 10;                          % Operating cost per vehicle on route X
int: cost_Y = 20;                          % Operating cost per vehicle on route Y
int: cost_Z = 30;                          % Operating cost per vehicle on route Z

int: cap_X = 500;                          % Maximum capacity on route X
int: cap_Y = 300;                          % Maximum capacity on route Y
int: cap_Z = 200;                          % Maximum capacity on route Z

% Variables
var 0..cap_X: vehicles_X;                  % Number of vehicles assigned to route X
var 0..cap_Y: vehicles_Y;                  % Number of vehicles assigned to route Y
var 0..cap_Z: vehicles_Z;                  % Number of vehicles assigned to route Z

% Upper bound is the max possible cost given route capacities
var 0..(cost_X*cap_X + cost_Y*cap_Y + cost_Z*cap_Z): total_cost;

% Constraints
% Total vehicle availability (do not exceed total stock)
constraint vehicles_X + vehicles_Y + vehicles_Z <= total_vehicles_limit;

% Safety requirement: route X must have at least min_diff_XY more vehicles than route Y
constraint vehicles_X >= vehicles_Y + min_diff_XY;

% Traffic balance: the difference between routes Y and Z cannot exceed max_abs_diff_YZ
constraint abs(vehicles_Y - vehicles_Z) <= max_abs_diff_YZ;

% Total operating cost definition (linking total_cost to decision variables)
constraint total_cost = cost_X * vehicles_X + cost_Y * vehicles_Y + cost_Z * vehicles_Z;

% Objective
solve minimize total_cost;