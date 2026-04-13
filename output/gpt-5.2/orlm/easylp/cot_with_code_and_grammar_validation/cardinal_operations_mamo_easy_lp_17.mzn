% Parameters
int: min_total_invest = 30;
int: max_resource = 150;
int: res_x = 5;
int: res_y = 3;
int: cost_x = 40;
int: cost_y = 50;

% Variables
var 0..max_resource: X;
var 0..max_resource: Y;
var 0..(cost_x*max_resource + cost_y*max_resource): total_cost;

% Constraints
constraint X + Y >= min_total_invest;
constraint res_x * X + res_y * Y <= max_resource;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;