% Parameters
int: total_resource = 60;
int: resource_per_X = 2;
int: resource_per_Y = 3;
int: min_projects = 10;
int: cost_X = 1000;
int: cost_Y = 500;

% Variables
var 0..(total_resource div resource_per_X): x;
var 0..(total_resource div resource_per_Y): y;
var 0..(cost_X*(total_resource div resource_per_X) + cost_Y*(total_resource div resource_per_Y)): total_cost;

% Constraints
constraint resource_per_X * x + resource_per_Y * y <= total_resource;
constraint x + y >= min_projects;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;