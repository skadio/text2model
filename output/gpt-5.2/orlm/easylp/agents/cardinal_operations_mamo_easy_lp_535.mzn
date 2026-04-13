% Parameters
int: max_total_area = 500;              % Maximum total acres available
int: min_diversity_area = 200;          % Minimum required for 2*X + Y
int: max_yz_diff = 50;                  % Maximum allowed |Y - Z|
int: min_x_minus_halfz = 100;           % Minimum required for X - (Z/2) >= 100

int: cost_x = 100;                      % Cost per acre for crop X ($)
int: cost_y = 50;                       % Cost per acre for crop Y ($)
int: cost_z = 75;                       % Cost per acre for crop Z ($)

% Variables
var 0..max_total_area: acres_x;         % Acres allocated to crop X (integer)
var 0..max_total_area: acres_y;         % Acres allocated to crop Y (integer)
var 0..max_total_area: acres_z;         % Acres allocated to crop Z (integer)

var 0..(cost_x*max_total_area + cost_y*max_total_area + cost_z*max_total_area): total_cost;
                                        % Total cultivation cost ($), bounded

% Constraints

% Land availability: total cultivated area cannot exceed the available land
constraint
  acres_x + acres_y + acres_z <= max_total_area;

% Diversity requirement: ensure sufficient combined area of 2*X + Y
constraint
  2 * acres_x + acres_y >= min_diversity_area;

% Balance requirement: difference between Y and Z areas cannot exceed the limit
constraint
  abs(acres_y - acres_z) <= max_yz_diff;

% Production relationship: X - (Z/2) >= 100
% Avoid fractional division by multiplying both sides by 2: 2X - Z >= 200
constraint
  2 * acres_x - acres_z >= 2 * min_x_minus_halfz;

% Define total cost from per-acre costs
constraint
  total_cost = cost_x * acres_x + cost_y * acres_y + cost_z * acres_z;

% Objective
solve minimize total_cost;