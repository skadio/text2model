% Parameters
int: max_total_services = 200;
int: min_X = 50;
int: min_Y = 30;
int: cost_X = 300;
int: cost_Y = 500;

% Variables
var min_X..max_total_services: X;
var min_Y..max_total_services: Y;
var 0..(cost_X*max_total_services + cost_Y*max_total_services): total_cost;

% Constraints
constraint X + Y <= max_total_services;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;