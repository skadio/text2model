% Parameters
int: max_total_acres = 1000;          % Maximum total acres available
int: min_acres_X = 200;              % Minimum acres for crop X
int: min_acres_Y = 150;              % Minimum acres for crop Y
int: min_acres_Z = 100;              % Minimum acres for crop Z

int: cost_per_acre_X = 10;           % Cost per acre for crop X (dollars)
int: cost_per_acre_Y = 20;           % Cost per acre for crop Y (dollars)
int: cost_per_acre_Z = 30;           % Cost per acre for crop Z (dollars)

% Variables
var min_acres_X..max_total_acres: acres_X;  % Acres allocated to crop X (integer)
var min_acres_Y..max_total_acres: acres_Y;  % Acres allocated to crop Y (integer)
var min_acres_Z..max_total_acres: acres_Z;  % Acres allocated to crop Z (integer)

% Upper bound assumes each crop could (individually) take up to max_total_acres
var 0..(cost_per_acre_X*max_total_acres
     + cost_per_acre_Y*max_total_acres
     + cost_per_acre_Z*max_total_acres): total_cost;  % Total planting cost (dollars)

% Constraints
% Land availability constraint: total planted acres cannot exceed the maximum available
constraint
  acres_X + acres_Y + acres_Z <= max_total_acres;

% Total cost calculation: compute planting cost from per-acre costs and allocated acres
constraint
  total_cost =
    cost_per_acre_X * acres_X +
    cost_per_acre_Y * acres_Y +
    cost_per_acre_Z * acres_Z;

% Objective
solve minimize total_cost;