% Parameters
int: max_total_resources = 5000;          % Total available resources (budget cap)
int: min_XY_resources = 2000;             % Minimum resources allocated to X and Y combined
int: max_YZ_resources = 2500;             % Maximum resources allocated to Y and Z combined

int: cost_X = 50;                         % Cost per unit at location X
int: cost_Y = 30;                         % Cost per unit at location Y
int: cost_Z = 20;                         % Cost per unit at location Z

% Variables
var 0..max_total_resources: alloc_X;      % Units allocated to location X (integer, non-negative)
var 0..max_total_resources: alloc_Y;      % Units allocated to location Y (integer, non-negative)
var 0..max_total_resources: alloc_Z;      % Units allocated to location Z (integer, non-negative)

var 0..(cost_X*max_total_resources + cost_Y*max_total_resources + cost_Z*max_total_resources): total_cost;
                                          % Total cost (upper bound is worst-case allocation)

% Constraints
% --- Total resource availability (budget cap) ---
constraint
  alloc_X + alloc_Y + alloc_Z <= max_total_resources;

% --- Minimum resources for X and Y combined ---
constraint
  alloc_X + alloc_Y >= min_XY_resources;

% --- Relationship between X and Y allocations (X is twice Y) ---
constraint
  alloc_X = 2 * alloc_Y;

% --- Capacity/limit on Y and Z combined ---
constraint
  alloc_Y + alloc_Z <= max_YZ_resources;

% --- Define total cost from allocations and per-unit costs ---
constraint
  total_cost = cost_X * alloc_X + cost_Y * alloc_Y + cost_Z * alloc_Z;

% Objective
solve minimize total_cost;