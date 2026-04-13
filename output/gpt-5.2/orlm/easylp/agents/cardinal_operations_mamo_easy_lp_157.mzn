% Parameters
% Maximum total number of properties that can be purchased
int: max_total_properties = 1000;

% Costs per property type (in dollars)
int: cost_X = 300000;
int: cost_Y = 200000;

% Diversity requirement multiplier: X >= multiplier * Y
int: diversity_multiplier = 3;

% Variables
% Number of type X properties purchased (non-negative integer, bounded by total limit)
var 0..max_total_properties: num_X;

% Number of type Y properties purchased (non-negative integer, bounded by total limit)
var 0..max_total_properties: num_Y;

% Total cost (non-negative integer, explicit upper bound from max properties and max unit cost)
var 0..(max_total_properties * max(cost_X, cost_Y)): total_cost;

% Constraints
% --- Total number of properties limit ---
constraint
  num_X + num_Y <= max_total_properties;

% --- Diversity requirement: ensure enough X relative to Y ---
constraint
  num_X >= diversity_multiplier * num_Y;

% --- Total cost calculation (linking variable total_cost to decision variables) ---
constraint
  total_cost = cost_X * num_X + cost_Y * num_Y;

% Objective
solve minimize total_cost;