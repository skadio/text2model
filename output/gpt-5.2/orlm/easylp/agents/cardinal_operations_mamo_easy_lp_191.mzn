% Parameters
% Operating cost per vehicle on each route
int: cost_x = 5;
int: cost_y = 7;
int: cost_z = 3;

% Constraint constants
int: max_total_vehicles = 1000;
int: min_weighted_xy = 500;      % 2*X + 3*Y >= 500
int: max_xz_minus_y = 400;       % X + Z - Y <= 400
int: min_y_minus_z = 100;        % Y >= Z + 100

% Variables
% Number of vehicles allocated to each route (integers, non-negative, bounded)
var 0..max_total_vehicles: vehicles_x;
var 0..max_total_vehicles: vehicles_y;
var 0..max_total_vehicles: vehicles_z;

% Total operating cost (upper bound: worst-case all vehicles on most expensive route)
var 0..(max_total_vehicles * max(cost_x, max(cost_y, cost_z))): total_cost;

% Constraints
% Total vehicle limit
constraint
  vehicles_x + vehicles_y + vehicles_z <= max_total_vehicles;

% Weighted requirement for routes X and Y
constraint
  2 * vehicles_x + 3 * vehicles_y >= min_weighted_xy;

% Net constraint involving X, Y, Z
constraint
  vehicles_x + vehicles_z - vehicles_y <= max_xz_minus_y;

% Y must exceed Z by at least 100
constraint
  vehicles_y >= vehicles_z + min_y_minus_z;

% Define total cost
constraint
  total_cost = cost_x * vehicles_x + cost_y * vehicles_y + cost_z * vehicles_z;

% Objective
solve minimize total_cost;