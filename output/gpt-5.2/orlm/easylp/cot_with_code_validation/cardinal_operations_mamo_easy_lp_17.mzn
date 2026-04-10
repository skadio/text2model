% Parameters
int: min_total_invest = 30;
int: max_resource_use = 150;
int: resource_x = 5;
int: resource_y = 3;
int: cost_x = 40;
int: cost_y = 50;

% Variables
var 0..max_resource_use div resource_x: X;
var 0..max_resource_use div resource_y: Y;
var 0..(cost_x*(max_resource_use div resource_x) + cost_y*(max_resource_use div resource_y)): total_cost;

% Constraints
constraint X + Y >= min_total_invest;
constraint resource_x * X + resource_y * Y <= max_resource_use;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;