% Parameters (with values embedded)
int: resource_limit = 60;
int: resource_per_X = 2;
int: resource_per_Y = 3;
int: min_total_projects = 10;

int: cost_X = 1000;
int: cost_Y = 500;

% Variables
var 0..(resource_limit div resource_per_X): x; % number of X projects
var 0..(resource_limit div resource_per_Y): y; % number of Y projects

% Constraints
constraint resource_per_X * x + resource_per_Y * y <= resource_limit;
constraint x + y >= min_total_projects;

% Objective
var int: total_cost = cost_X * x + cost_Y * y;
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];