% Parameters
int: max_total_area = 500;                 % Maximum total acres available
int: min_diversity_area = 200;             % Minimum required for 2*X + Y
int: max_yz_diff = 50;                     % Maximum allowed absolute difference |Y - Z|
int: min_x_minus_halfz = 100;              % Minimum required for X - (Z/2) >= 100 (handled via 2*X - Z >= 200)

int: cost_x = 100;                         % Cost per acre for crop X
int: cost_y = 50;                          % Cost per acre for crop Y
int: cost_z = 75;                          % Cost per acre for crop Z


% Variables
var 0..max_total_area: area_x;             % Acres allocated to crop X (integer)
var 0..max_total_area: area_y;             % Acres allocated to crop Y (integer)
var 0..max_total_area: area_z;             % Acres allocated to crop Z (integer)

% Upper bound: all acres at the most expensive crop (X) plus others; safe integer bound
var 0..(cost_x*max_total_area + cost_y*max_total_area + cost_z*max_total_area): total_cost;


% Constraints
% Total land availability: X + Y + Z <= max_total_area
constraint area_x + area_y + area_z <= max_total_area;

% Diversity requirement: 2*X + Y >= min_diversity_area
constraint 2 * area_x + area_y >= min_diversity_area;

% Balance requirement between Y and Z: |Y - Z| <= max_yz_diff
constraint abs(area_y - area_z) <= max_yz_diff;

% Relationship between X and Z:
% X - (Z/2) >= min_x_minus_halfz  ==>  2*X - Z >= 2*min_x_minus_halfz
constraint 2 * area_x - area_z >= 2 * min_x_minus_halfz;

% Define total_cost from per-acre costs
constraint total_cost = cost_x * area_x + cost_y * area_y + cost_z * area_z;


% Objective
solve minimize total_cost;