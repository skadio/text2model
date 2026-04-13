% Parameters
int: total_resource = 60;
int: res_per_X = 2;
int: res_per_Y = 3;
int: min_projects = 10;
int: cost_X = 1000;
int: cost_Y = 500;

% Variables
var 0..(total_resource div res_per_X): X;
var 0..(total_resource div res_per_Y): Y;
var 0..(cost_X * (total_resource div res_per_X) + cost_Y * (total_resource div res_per_Y)): total_cost;

% Constraints
constraint res_per_X * X + res_per_Y * Y <= total_resource;
constraint X + Y >= min_projects;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;