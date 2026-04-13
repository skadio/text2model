% Parameters
int: resource_limit = 60;
int: resource_per_X = 2;
int: resource_per_Y = 3;
int: min_projects = 10;
int: cost_X = 1000;
int: cost_Y = 500;

% Variables
var 0..(resource_limit div resource_per_X): X;
var 0..(resource_limit div resource_per_Y): Y;
var 0..(cost_X * (resource_limit div resource_per_X) + cost_Y * (resource_limit div resource_per_Y)): total_cost;

% Constraints
constraint resource_per_X * X + resource_per_Y * Y <= resource_limit;
constraint X + Y >= min_projects;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;