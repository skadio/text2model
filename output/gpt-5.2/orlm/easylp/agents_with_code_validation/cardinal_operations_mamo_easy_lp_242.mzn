% Parameters
int: max_projects = 50;                  % Maximum total number of projects
int: min_effectiveness = 150;            % Minimum required effectiveness score
int: max_xy_diff = 10;                   % Maximum allowed absolute difference between X and Y

int: eff_X = 3;                          % Effectiveness per X project
int: eff_Y = 4;                          % Effectiveness per Y project
int: eff_Z = 5;                          % Effectiveness per Z project

int: cost_X = 2000;                      % Cost per X project (dollars)
int: cost_Y = 3000;                      % Cost per Y project (dollars)
int: cost_Z = 4000;                      % Cost per Z project (dollars)

% Variables
var 0..max_projects: x;                  % Number of X projects (integer, nonnegative)
var 0..max_projects: y;                  % Number of Y projects (integer, nonnegative)
var 0..max_projects: z;                  % Number of Z projects (integer, nonnegative)

var 0..(cost_X*max_projects + cost_Y*max_projects + cost_Z*max_projects): total_cost;
                                         % Total cost (bounded integer)

% Constraints
% Total number of projects limited by manpower
constraint x + y + z <= max_projects;

% Minimum combined effectiveness requirement
constraint eff_X * x + eff_Y * y + eff_Z * z >= min_effectiveness;

% Limit the absolute difference between X and Y projects
constraint abs(x - y) <= max_xy_diff;

% Define total cost from per-project costs
constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;

% Optional output (helps confirm the minimum cost and chosen quantities)
output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];