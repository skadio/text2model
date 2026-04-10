% Parameters
% Capacity usage per shipment to each port
int: cap_per_x = 4;
int: cap_per_y = 5;

% Total combined capacity limit
int: total_capacity = 2000;

% Balance requirement: shipments to X exceed shipments to Y by at least this amount
int: min_excess_x_over_y = 50;

% Logistical constraint limit for (X + 2*Y)
int: weighted_volume_limit = 1500;

% Cost per shipment to each port
int: cost_per_x = 2;
int: cost_per_y = 3;

% Variables
% Number of shipments to each port (whole numbers, non-negative)
var 0..500: ship_x;  % upper bound from 4*ship_x <= 2000 => ship_x <= 500
var 0..400: ship_y;  % upper bound from 5*ship_y <= 2000 => ship_y <= 400

% Total cost in dollars (bounded for safe linear modeling)
var 0..(cost_per_x*500 + cost_per_y*400): total_cost;

% Constraints
% Capacity constraint: combined capacity usage at both ports cannot exceed total capacity
constraint
  cap_per_x * ship_x + cap_per_y * ship_y <= total_capacity;

% Balance constraint: shipments to X must exceed shipments to Y by at least the minimum excess
constraint
  ship_x - ship_y >= min_excess_x_over_y;

% Logistical constraint: weighted shipment volume (X + 2*Y) cannot exceed the specified limit
constraint
  ship_x + 2 * ship_y <= weighted_volume_limit;

% Cost definition: total cost equals sum of per-shipment costs for each port
constraint
  total_cost = cost_per_x * ship_x + cost_per_y * ship_y;

% Objective
solve minimize total_cost;