% Parameters
% Budget limits and minimum combined investment (all in dollars)
int: max_xy = 1000;      % X + Y must be <= 1000
int: max_yz = 800;       % Y + Z must be <= 800
int: min_xz = 500;       % X + Z must be >= 500

% ROI per dollar (given, though not required for the "minimize total cost" objective)
int: roi_x = 2;
int: roi_y = 3;
int: roi_z = 5;

% Variables
% Investment amounts (whole dollars, non-negative)
% Upper bounds chosen to be safe and consistent with the constraints
var 0..max(max_xy, min_xz): invest_x;  % dollars in channel X
var 0..max(max_xy, max_yz): invest_y;  % dollars in channel Y
var 0..max(max_yz, min_xz): invest_z;  % dollars in channel Z

% Total cost to minimize
var 0..(max_xy + max_yz): total_cost;  % invest_x + invest_y + invest_z

% Constraints
% Budget constraints for channel pairs
constraint invest_x + invest_y <= max_xy;   % X + Y must not exceed 1000
constraint invest_y + invest_z <= max_yz;   % Y + Z must not exceed 800

% Minimum combined investment requirement
constraint invest_x + invest_z >= min_xz;   % X + Z must be at least 500

% Define total cost as the sum of investments
constraint total_cost = invest_x + invest_y + invest_z;

% Objective
solve minimize total_cost;