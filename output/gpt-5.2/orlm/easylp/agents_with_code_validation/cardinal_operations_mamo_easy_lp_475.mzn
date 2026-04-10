% Parameters
int: max_total_packages = 50;          % Upper limit on total packages X + Y
int: min_total_packages = 10;          % Lower limit on total packages X + Y
int: max_excess_x_over_2y = 20;        % Constraint: X - 2*Y <= 20
int: resource_per_x = 100;             % Resource units required per package X
int: resource_per_y = 150;             % Resource units required per package Y

% Variables
var 0..max_total_packages: x_packages; % Number of package X
var 0..max_total_packages: y_packages; % Number of package Y

% Total resource units used (bounded by worst-case total if both at max_total_packages)
var 0..(resource_per_x * max_total_packages + resource_per_y * max_total_packages): total_resources;

% Constraints
% Total number of packages must respect overall capacity and minimum offering
constraint x_packages + y_packages <= max_total_packages;
constraint x_packages + y_packages >= min_total_packages;

% Balance constraint: X should not exceed (2*Y + allowed excess)
constraint x_packages - 2 * y_packages <= max_excess_x_over_2y;

% Define total resource usage from chosen package counts
constraint total_resources = resource_per_x * x_packages + resource_per_y * y_packages;

% Objective
solve minimize total_resources;

output [
  "x_packages=", show(x_packages), "\n",
  "y_packages=", show(y_packages), "\n",
  "total_resources=", show(total_resources), "\n"
];