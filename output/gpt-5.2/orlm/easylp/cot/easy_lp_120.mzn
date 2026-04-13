% Parameters (with values embedded)
int: max_services = 200;
int: min_X = 50;
int: min_Y = 30;
int: cost_X = 300;
int: cost_Y = 500;

% Variables
var min_X..max_services: X;
var min_Y..max_services: Y;
var 0..(max_services * max(cost_X, cost_Y)): total_cost;

% Constraints
constraint X + Y <= max_services;
constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;