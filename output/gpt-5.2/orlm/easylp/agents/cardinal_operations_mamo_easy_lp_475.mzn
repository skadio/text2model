% Parameters
int: max_total_packages = 50;          % Upper limit on total number of packages
int: min_total_packages = 10;          % Lower limit on total number of packages (diversity)
int: res_per_x = 100;                  % Resources required per package X
int: res_per_y = 150;                  % Resources required per package Y
int: balance_slack = 20;               % Slack allowed in balance constraint

% Variables
var 0..max_total_packages: x_packages; % Number of package X offered (integer, nonnegative, bounded)
var 0..max_total_packages: y_packages; % Number of package Y offered (integer, nonnegative, bounded)
var 0..(res_per_x * max_total_packages + res_per_y * max_total_packages): total_resources;
                                       % Total resources used (bounded for linear objective)

% Constraints
% Total number of packages must respect logistical upper limit
constraint x_packages + y_packages <= max_total_packages;

% Total number of packages must respect diversity lower limit
constraint x_packages + y_packages >= min_total_packages;

% Balance constraint: X should not exceed twice Y by more than the allowed slack
constraint x_packages - 2 * y_packages <= balance_slack;

% Define total resources as the linear combination of resources per package type
constraint total_resources = res_per_x * x_packages + res_per_y * y_packages;

% Objective
solve minimize total_resources;