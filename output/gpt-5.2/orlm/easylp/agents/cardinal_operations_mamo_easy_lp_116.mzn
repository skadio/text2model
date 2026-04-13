% Parameters
int: max_total_packages = 100;          % Capacity limit on total packages sold
int: max_x_packages = 70;               % Upper bound for X packages
int: max_y_packages = 50;               % Upper bound for Y packages
int: cost_x = 50;                       % Cost per X package
int: cost_y = 80;                       % Cost per Y package
int: min_x_offset = 10;                 % X must be at least 10 more than twice Y
int: max_representation_diff = 20;      % Upper limit for (Y - X/2)

% Variables
var 0..max_x_packages: x_packages;      % Number of X packages sold (integer, non-negative)
var 0..max_y_packages: y_packages;      % Number of Y packages sold (integer, non-negative)
var 0..(cost_x*max_x_packages + cost_y*max_y_packages): total_cost; % Total cost to minimize

% Constraints

% Total capacity constraint: total packages sold cannot exceed overall limit
constraint
  x_packages + y_packages <= max_total_packages;

% Portfolio diversity constraint: X must be at least (2 * Y + offset)
constraint
  x_packages >= 2 * y_packages + min_x_offset;

% Representation balance constraint: (Y - X/2) must not exceed the allowed difference
% Use integer arithmetic to avoid non-integer division: 2*Y - X <= 2*max_diff
constraint
  2 * y_packages - x_packages <= 2 * max_representation_diff;

% Total cost definition (linking variable total_cost to decision variables)
constraint
  total_cost = cost_x * x_packages + cost_y * y_packages;

% Objective
solve minimize total_cost;