% Parameters
int: max_total_projects = 50;                % Total projects capacity limit
int: min_effectiveness = 150;                % Minimum required effectiveness score
int: max_diff_xy = 10;                       % Maximum allowed difference between X and Y projects

int: eff_x = 3;                              % Effectiveness per X project
int: eff_y = 4;                              % Effectiveness per Y project
int: eff_z = 5;                              % Effectiveness per Z project

int: cost_x = 2000;                          % Cost per X project (dollars)
int: cost_y = 3000;                          % Cost per Y project (dollars)
int: cost_z = 4000;                          % Cost per Z project (dollars)

% Variables
var 0..max_total_projects: num_x;            % Number of X projects (integer, nonnegative)
var 0..max_total_projects: num_y;            % Number of Y projects (integer, nonnegative)
var 0..max_total_projects: num_z;            % Number of Z projects (integer, nonnegative)

var 0..(cost_z * max_total_projects): total_cost;  % Total cost upper bound: 4000 * 50

% Constraints
% Total projects capacity limit
constraint num_x + num_y + num_z <= max_total_projects;

% Minimum required effectiveness score
constraint eff_x * num_x + eff_y * num_y + eff_z * num_z >= min_effectiveness;

% Limit the absolute difference between X and Y projects
constraint abs(num_x - num_y) <= max_diff_xy;

% Define total cost from decision variables and per-project costs
constraint total_cost = cost_x * num_x + cost_y * num_y + cost_z * num_z;

% Objective
solve minimize total_cost;