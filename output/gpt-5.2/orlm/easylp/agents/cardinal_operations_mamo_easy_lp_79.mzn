% Parameters
int: max_resources = 60;                 % Total available resource units
int: min_projects = 10;                  % Minimum total number of projects required

int: resource_per_X = 2;                 % Resource units needed per X project
int: resource_per_Y = 3;                 % Resource units needed per Y project

int: cost_per_X = 1000;                  % Cost in dollars per X project
int: cost_per_Y = 500;                   % Cost in dollars per Y project

% Variables
var 0..(max_resources div resource_per_X): x_projects;  % Number of X projects (integer, bounded)
var 0..(max_resources div resource_per_Y): y_projects;  % Number of Y projects (integer, bounded)

var 0..(cost_per_X*(max_resources div resource_per_X) + cost_per_Y*(max_resources div resource_per_Y)):
  total_cost;                                            % Total cost (bounded)

% Constraints

% Resource capacity constraint: total resources used by X and Y cannot exceed max_resources
constraint
  resource_per_X * x_projects + resource_per_Y * y_projects <= max_resources;

% Minimum output constraint: total number of projects must be at least min_projects
constraint
  x_projects + y_projects >= min_projects;

% Total cost definition: link total_cost to the chosen numbers of projects
constraint
  total_cost = cost_per_X * x_projects + cost_per_Y * y_projects;

% Objective
solve minimize total_cost;

% Optional output for clarity
output [
  "x_projects=", show(x_projects), "\n",
  "y_projects=", show(y_projects), "\n",
  "total_cost=", show(total_cost), "\n"
];