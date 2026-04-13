% Parameters
int: max_total_packages = 500;          % Maximum total number of packages (X+Y+Z)
int: min_xy_sum = 200;                 % Minimum required sum of packages X+Y
int: max_yz_diff = 150;                % Maximum allowed absolute difference |Y-Z|

int: cost_X = 50;                      % Cost per unit of package X
int: cost_Y = 30;                      % Cost per unit of package Y
int: cost_Z = 100;                     % Cost per unit of package Z


% Variables
var 0..max_total_packages: x;          % Number of package X (nonnegative integer)
var 0..max_total_packages: y;          % Number of package Y (nonnegative integer)
var 0..max_total_packages: z;          % Number of package Z (nonnegative integer)

% Total cost (upper bound: all packages at max cost)
var 0..(cost_X + cost_Y + cost_Z) * max_total_packages: total_cost;


% Constraints
% Tie cost variable to decisions
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Capacity / availability constraints
constraint x + y + z <= max_total_packages;

% Service requirement constraints
constraint x + y >= min_xy_sum;

% Preference / balance constraints
% Package X should not be less than half of package Y: x >= y/2  <=>  2x >= y
constraint 2 * x >= y;

% Difference between Y and Z should not exceed max_yz_diff
constraint abs(y - z) <= max_yz_diff;


% Objective
solve minimize total_cost;