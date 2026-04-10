% Parameters
% Maximum total resource units available (budget constraint)
int: max_total_resources = 100;

% Minimum required combined effectiveness (X + Y)
int: min_effectiveness = 20;

% Cost per unit (objective weights) for each department
int: cost_x = 2;
int: cost_y = 3;

% Variables
% Integer resource allocation to Emergency (X)
var 0..max_total_resources: x;

% Integer resource allocation to Surgery (Y)
var 0..max_total_resources: y;

% Total (weighted) resource usage to be minimized: cost_x*x + cost_y*y
var 0..(cost_x*max_total_resources + cost_y*max_total_resources): total_resource_usage;

% Constraints
% Link total_resource_usage to the weighted allocations
constraint total_resource_usage = cost_x * x + cost_y * y;

% Budget constraint: combined allocated units cannot exceed available resources
constraint x + y <= max_total_resources;

% Effectiveness constraint: combined effectiveness must meet the minimum requirement
constraint x + y >= min_effectiveness;

% Objective
solve minimize total_resource_usage;